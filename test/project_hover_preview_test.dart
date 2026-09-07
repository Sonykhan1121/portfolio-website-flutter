import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/data/portfolio_data.dart';
import 'package:portfolio_website_flutter/widgets/project_hover_preview.dart';

const _asset = 'hover-test.webp';
const _preview = ValueKey('preview-ready:Project');

class _PreviewBundle extends CachingAssetBundle {
  final request = Completer<ByteData>();
  int loads = 0;

  @override
  Future<ByteData> load(String key) {
    if (key == _asset) {
      loads++;
      return request.future;
    }
    return rootBundle.load(key);
  }
}

Widget _app({
  AssetBundle? bundle,
  String? asset,
  String? code,
  bool reducedMotion = false,
  VoidCallback? onTap,
}) => MaterialApp(
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reducedMotion),
    child: DefaultAssetBundle(
      bundle: bundle ?? rootBundle,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 360,
            height: 394,
            child: InkWell(
              onTap: onTap ?? () {},
              child: ProjectHoverPreview(
                title: 'Project',
                linkLabel: 'View on GitHub',
                accent: Colors.teal,
                asset: asset,
                code: code,
                child: const SizedBox.expand(child: Text('Original card')),
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

Future<TestGesture> _hover(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  await mouse.moveTo(tester.getCenter(find.byType(ProjectHoverPreview)));
  return mouse;
}

void main() {
  test('all six cards have sourced previews and gallery assets', () {
    expect(featuredProjects.length, 6);
    var totalBytes = 0;
    for (final project in featuredProjects) {
      if (project.previewAsset != null) {
        final file = File(project.previewAsset!);
        expect(file.existsSync(), isTrue, reason: project.title);
        totalBytes += file.lengthSync();
      } else {
        expect(project.title, 'BD SIM Validator');
        expect(project.previewCode, contains('BDPhoneValidator.isValid'));
      }
    }
    expect(totalBytes, lessThan(300000));
    expect(featuredProjects.map((project) => project.screenshots.length), [
      14,
      15,
      2,
      6,
      9,
      2,
    ]);
    for (final project in featuredProjects) {
      for (final image in project.screenshots) {
        expect(
          File(image.$2).existsSync(),
          isTrue,
          reason: '${project.title}: ${image.$1}',
        );
      }
    }
    expect(featuredProjects.last.title, 'Face Recognition');
    expect(featuredProjects.last.previewLabel, contains('SIMULATED'));
    expect(
      featuredProjects.last.previewAsset,
      'assets/images/projects/hover-face-recognition.webp',
    );
  });

  testWidgets(
    'hover is delayed and exiting cancels it without loading assets',
    (tester) async {
      final bundle = _PreviewBundle();
      await tester.pumpWidget(_app(bundle: bundle, asset: _asset));
      expect(bundle.loads, 0);
      final mouse = await _hover(tester);
      await tester.pump(const Duration(milliseconds: 100));
      expect(bundle.loads, 0);
      await mouse.moveTo(Offset.zero);
      await tester.pump(const Duration(seconds: 1));
      expect(bundle.loads, 0);
      expect(find.byKey(_preview), findsNothing);
      await mouse.removePointer();
    },
  );

  testWidgets(
    'decoded preview fits the card, passes clicks and restores on exit',
    (tester) async {
      final bundle = _PreviewBundle();
      var clicks = 0;
      await tester.pumpWidget(
        _app(bundle: bundle, asset: _asset, onTap: () => clicks++),
      );
      final size = tester.getSize(find.byType(ProjectHoverPreview));
      final mouse = await _hover(tester);
      await tester.pump(const Duration(milliseconds: 180));
      await tester.pump();
      expect(bundle.loads, 1);
      expect(find.byKey(_preview), findsNothing);
      expect(find.text('Original card'), findsOneWidget);

      final bytes =
          File(
            'assets/images/projects/hover-money-mate.webp',
          ).readAsBytesSync();
      bundle.request.complete(ByteData.sublistView(bytes));
      await tester.runAsync(() async {
        await precacheImage(
          AssetImage(_asset, bundle: bundle),
          tester.element(find.byType(ProjectHoverPreview)),
        );
      });
      await tester.pumpAndSettle();
      expect(find.byKey(_preview), findsOneWidget);
      expect(tester.getSize(find.byType(ProjectHoverPreview)), size);
      expect(tester.getSize(find.byKey(_preview)), size);
      expect(
        find.ancestor(
          of: find.byKey(_preview),
          matching: find.byWidgetPredicate(
            (widget) => widget is IgnorePointer && widget.ignoring,
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byKey(_preview),
          matching: find.byWidgetPredicate(
            (widget) => widget is ExcludeSemantics && widget.excluding,
          ),
        ),
        findsOneWidget,
      );
      await mouse.down(tester.getCenter(find.byType(ProjectHoverPreview)));
      await mouse.up();
      expect(clicks, 1);
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.byKey(_preview), findsNothing);
      expect(tester.getSize(find.byType(ProjectHoverPreview)), size);
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
    },
  );

  testWidgets('failed screenshot keeps original content and link usable', (
    tester,
  ) async {
    final bundle = _PreviewBundle();
    var clicks = 0;
    await tester.pumpWidget(
      _app(bundle: bundle, asset: _asset, onTap: () => clicks++),
    );
    final mouse = await _hover(tester);
    await tester.pump(const Duration(milliseconds: 180));
    bundle.request.completeError(StateError('Offline'));
    await tester.pumpAndSettle();
    expect(find.byKey(_preview), findsNothing);
    expect(find.text('Original card'), findsOneWidget);
    await tester.tap(find.byType(ProjectHoverPreview));
    expect(clicks, 1);
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });

  testWidgets('touch navigates without a preview or any image request', (
    tester,
  ) async {
    final bundle = _PreviewBundle();
    var clicks = 0;
    await tester.pumpWidget(
      _app(bundle: bundle, asset: _asset, onTap: () => clicks++),
    );
    final touch = await tester.startGesture(
      tester.getCenter(find.byType(ProjectHoverPreview)),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await touch.up();
    await tester.pumpAndSettle();
    expect(clicks, 1);
    expect(bundle.loads, 0);
    expect(find.byKey(_preview), findsNothing);
  });

  testWidgets(
    'Escape dismisses preview; keyboard activation remains available',
    (tester) async {
      var clicks = 0;
      await tester.pumpWidget(_app(code: 'Example', onTap: () => clicks++));
      final mouse = await _hover(tester);
      await tester.pumpAndSettle(const Duration(milliseconds: 180));
      expect(find.byKey(_preview), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byKey(_preview), findsNothing);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(clicks, 1);
      await mouse.removePointer();
    },
  );

  testWidgets('reduced motion uses no fade; pause and dispose clean up', (
    tester,
  ) async {
    await tester.pumpWidget(_app(code: 'Example', reducedMotion: true));
    final mouse = await _hover(tester);
    await tester.pump(const Duration(milliseconds: 180));
    final animation = tester.widget<TweenAnimationBuilder<double>>(
      find.byKey(_preview),
    );
    expect(animation.duration, Duration.zero);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(find.byKey(_preview), findsNothing);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await mouse.moveTo(Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(ProjectHoverPreview)));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });
}
