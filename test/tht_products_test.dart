import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/portfolio_app.dart';
import 'package:portfolio_website_flutter/widgets/progressive_asset_image.dart';

Widget _companyPage({double textScale = 1}) => MaterialApp(
  builder:
      (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: true,
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
  home: const ThtSpacePage(),
);

void main() {
  testWidgets('official product photos fit responsive and enlarged layouts', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final layout in [
      (360.0, 1.0),
      (768.0, 1.0),
      (1024.0, 1.0),
      (1440.0, 1.0),
      (390.0, 2.0),
    ]) {
      tester.view.physicalSize = Size(layout.$1, 1000);
      await tester.pumpWidget(_companyPage(textScale: layout.$2));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('View product'), findsNWidgets(4));
      // Product images are well below the cover: do not request them at entry.
      final firstPhoto = find.descendant(
        of: find.byKey(const ValueKey('tht-product-0')),
        matching: find.byType(ProgressiveAssetImage),
      );
      expect(
        find.descendant(of: firstPhoto, matching: find.byType(Image)),
        findsNothing,
      );
      for (var index = 0; index < 4; index++) {
        final card = find.byKey(ValueKey('tht-product-$index'));
        final photo = find.descendant(
          of: card,
          matching: find.byType(ProgressiveAssetImage),
        );
        expect(photo, findsOneWidget);
        final image = tester.widget<ProgressiveAssetImage>(photo);
        expect(image.asset, startsWith('assets/images/company/product-'));
        expect(image.fit, BoxFit.contain);
        expect(image.semanticLabel, contains('official product photo'));
        await Scrollable.ensureVisible(tester.element(photo));
        await tester.pump(const Duration(milliseconds: 250));
        expect(tester.getSize(photo).height, greaterThan(100));
        expect(
          tester.takeException(),
          isNull,
          reason: 'Product $index at ${layout.$1}px / ${layout.$2}x text',
        );
      }
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

  testWidgets(
    'bundled product images decode and product links open the catalog',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final launched = <String>[];
      const channel = MethodChannel('plugins.flutter.io/url_launcher');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        if (call.method == 'launch') {
          launched.add((call.arguments as Map)['url'] as String);
        }
        return true;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        ),
      );
      await tester.pumpWidget(_companyPage());
      await tester.pump(const Duration(milliseconds: 100));
      for (var index = 0; index < 4; index++) {
        final card = find.byKey(ValueKey('tht-product-$index'));
        final photo = tester.widget<ProgressiveAssetImage>(
          find.descendant(
            of: card,
            matching: find.byType(ProgressiveAssetImage),
          ),
        );
        await tester.runAsync(() async {
          final data = await rootBundle.load(photo.asset);
          final codec = await ui.instantiateImageCodec(
            data.buffer.asUint8List(),
          );
          final frame = await codec.getNextFrame();
          expect(frame.image.width, greaterThan(200));
          expect(frame.image.height, greaterThan(200));
          frame.image.dispose();
          codec.dispose();
        });
        final link = find.descendant(
          of: card,
          matching: find.text('View product'),
        );
        await Scrollable.ensureVisible(tester.element(link), alignment: 0.5);
        await tester.pump();
        await tester.tap(link);
        await tester.pump();
      }
      expect(launched.toSet(), hasLength(4));
      for (final url in launched) {
        expect(Uri.parse(url).scheme, 'https');
        expect(Uri.parse(url).host, 'printernoble.com');
        expect(Uri.parse(url).path, contains('product'));
      }
      expect(tester.takeException(), isNull);
    },
  );
}
