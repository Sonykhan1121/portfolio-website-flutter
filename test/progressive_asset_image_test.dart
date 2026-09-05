import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
