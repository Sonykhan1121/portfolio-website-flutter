import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/data/asset_image_previews.dart';
import 'package:portfolio_website_flutter/widgets/progressive_asset_image.dart';

const _icon = 'assets/images/projects/grozziie/icon.webp';
const _screen = 'assets/images/projects/grozziie/play_01.webp';

Finder _requestedAsset(String asset) => find.byWidgetPredicate(
  (widget) =>
      widget is Image &&
      widget.image is AssetImage &&
      (widget.image as AssetImage).assetName == asset,
);

void main() {
  test(
    'every embedded preview is a valid small image for an existing asset',
    () async {
      var bytes = 0;
      for (final asset in assetImagePreviews.keys) {
        expect(File(asset).existsSync(), isTrue, reason: asset);
        final preview = assetPreviewBytes(asset)!;
        bytes += preview.length;
        expect(identical(preview, assetPreviewBytes(asset)), isTrue);
        final codec = await ui.instantiateImageCodec(preview);
        final frame = await codec.getNextFrame();
        expect(frame.image.width, lessThanOrEqualTo(80));
        expect(frame.image.height, lessThanOrEqualTo(80));
        frame.image.dispose();
        codec.dispose();
      }
      expect(bytes, lessThan(30000));
      expect(assetPreviewBytes('assets/unknown.webp'), isNull);
    },
  );

  test('full-screen loader keeps the hero image prioritized', () {
    final html = File('web/index.html').readAsStringSync();
    expect(html, contains('<div class="monogram">SM</div>'));
    expect(html, contains('<div class="ring inner-ring"></div>'));
    expect(
      html,
      contains(
        'as="image" href="assets/assets/images/hero_portrait_2026_v2.webp" fetchpriority="high"',
      ),
    );
    expect(html, isNot(contains('id="startup-portrait"')));
    expect(
      File('assets/images/hero_portrait_2026_v2.webp').existsSync(),
      isTrue,
    );
  });

  testWidgets(
    'real previews exist before offscreen full images are requested',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2000),
                  ProgressiveAssetImage(_screen, width: 250, height: 400),
                ],
              ),
            ),
          ),
        ),
      );
      expect(_requestedAsset(_screen), findsNothing);
      final preview = tester.widget<Image>(
        find.byKey(const ValueKey('preview:$_screen')),
      );
      expect(preview.image, isA<MemoryImage>());
      expect(find.byIcon(Icons.image_outlined), findsNothing);
    },
  );

  testWidgets('priority images are requested in their first build', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 2000),
                ProgressiveAssetImage(
                  _icon,
                  width: 74,
                  height: 74,
                  eager: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(_requestedAsset(_icon), findsOneWidget);
  });

  for (final reducedMotion in [false, true]) {
    testWidgets(
      'preview stays beneath the top-down reveal (reduced motion: $reducedMotion)',
      (tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: ProgressiveAssetImage(
              _icon,
              width: 74,
              height: 74,
              eager: true,
            ),
          ),
        );
        final image = tester.widget<Image>(_requestedAsset(_icon));
        final element = tester.element(_requestedAsset(_icon));
        // Exercise the exact first decoded frame with a controlled image child.
        final frame = image.frameBuilder!(
          element,
          const SizedBox.expand(),
          0,
          false,
        );
        final stack = frame as Stack;
        expect(stack.children.first, isA<ExcludeSemantics>());
        expect((stack.children.first as ExcludeSemantics).excluding, isTrue);
        expect(
          (stack.children.last as TweenAnimationBuilder<double>).tween.end,
          1,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(disableAnimations: reducedMotion),
              child: const ProgressiveAssetImage(
                _screen,
                width: 250,
                height: 400,
                eager: true,
              ),
            ),
          ),
        );
        final screenImage = tester.widget<Image>(_requestedAsset(_screen));
        final screenElement = tester.element(_requestedAsset(_screen));
        final loaded =
            screenImage.frameBuilder!(
                  screenElement,
                  const SizedBox.expand(),
                  0,
                  false,
                )
                as Stack;
        final reveal = loaded.children.last as TweenAnimationBuilder<double>;
        expect(
          reveal.duration,
          reducedMotion ? Duration.zero : const Duration(milliseconds: 520),
        );
        // The full-size image is clipped, never resized or stretched as it reveals.
        for (final amount in [0.0, 0.25, 0.5, 1.0]) {
          final clipped =
              reveal.builder(screenElement, amount, const SizedBox.expand())
                  as ClipRect;
          expect(
            clipped.clipper!.getClip(const Size(250, 400)),
            Rect.fromLTWH(0, 0, 250, 400 * amount),
          );
        }
        expect(
          screenImage.frameBuilder!(
            screenElement,
            const SizedBox(key: ValueKey('cached')),
            0,
            true,
          ),
          isA<SizedBox>(),
        );
      },
    );
  }

  testWidgets('failed full image retains the available real preview', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProgressiveAssetImage(
          _icon,
          width: 74,
          height: 74,
          eager: true,
          semanticLabel: 'Grozziie',
        ),
      ),
    );
    final image = tester.widget<Image>(_requestedAsset(_icon));
    final fallback = image.errorBuilder!(
      tester.element(_requestedAsset(_icon)),
      StateError('offline'),
      null,
    );
    await tester.pumpWidget(
      MaterialApp(home: SizedBox(width: 74, height: 74, child: fallback)),
    );
    expect(find.byKey(const ValueKey('preview:$_icon')), findsOneWidget);
    expect(find.byIcon(Icons.broken_image_outlined), findsNothing);
    expect(
      (fallback as Semantics).properties.label,
      contains('full image unavailable'),
    );
  });

  testWidgets('changing an image also changes its preview', (tester) async {
    Widget surface(String asset) => MaterialApp(
      home: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 2000),
            ProgressiveAssetImage(
              asset,
              key: const ValueKey('photo'),
              width: 250,
              height: 400,
            ),
          ],
        ),
      ),
    );
    await tester.pumpWidget(surface(_icon));
    expect(find.byKey(const ValueKey('preview:$_icon')), findsOneWidget);
    await tester.pumpWidget(surface(_screen));
    expect(find.byKey(const ValueKey('preview:$_icon')), findsNothing);
    expect(find.byKey(const ValueKey('preview:$_screen')), findsOneWidget);
  });

  testWidgets('offscreen assets wait for scrolling and retain their slot', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: controller,
            child: const Column(
              children: [
                ProgressiveAssetImage(_icon, width: 74, height: 74),
                SizedBox(height: 1800),
                ProgressiveAssetImage(
                  _screen,
                  key: ValueKey('lower-image'),
                  width: 250,
                  height: 400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final size = tester.getSize(find.byKey(const ValueKey('lower-image')));
    await tester.pumpAndSettle();
    expect(_requestedAsset(_icon), findsOneWidget);
    expect(_requestedAsset(_screen), findsNothing);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(_requestedAsset(_screen), findsOneWidget);
    expect(tester.getSize(find.byKey(const ValueKey('lower-image'))), size);
    controller.jumpTo(0);
    await tester.pumpAndSettle();
    expect(_requestedAsset(_screen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('nested horizontal gallery also responds to its outer scroll', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                const SizedBox(height: 2000),
                SizedBox(
                  height: 400,
                  child: PageView(
                    children: const [
                      ProgressiveAssetImage(_screen),
                      ProgressiveAssetImage(_icon),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_requestedAsset(_screen), findsNothing);
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(_requestedAsset(_screen), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-800, 0));
    await tester.pumpAndSettle();
    expect(_requestedAsset(_icon), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('resize reveals assets without scrolling', (tester) async {
    tester.view.physicalSize = const Size(390, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 1000),
                ProgressiveAssetImage(_icon, width: 74, height: 74),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(_requestedAsset(_icon), findsNothing);
    tester.view.physicalSize = const Size(390, 1400);
    await tester.pumpAndSettle();
    expect(_requestedAsset(_icon), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing images keep a stable, accessible fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProgressiveAssetImage(
            'assets/missing-test-image.webp',
            width: 100,
            height: 120,
            semanticLabel: 'Test portrait',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
    expect(
      tester.getSize(find.byType(ProgressiveAssetImage)),
      const Size(100, 120),
    );
    expect(tester.takeException(), isNull);
  });
}
