import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/data/portfolio_data.dart';
import 'package:portfolio_website_flutter/models/repository_item.dart';
import 'package:portfolio_website_flutter/portfolio_app.dart';
import 'package:portfolio_website_flutter/services/github_repository_service.dart';
import 'package:portfolio_website_flutter/widgets/project_hover_preview.dart';
import 'package:portfolio_website_flutter/widgets/progressive_asset_image.dart';
import 'package:portfolio_website_flutter/widgets/screenshot_gallery.dart';

class _OfflineRepositories extends GitHubRepositoryService {
  _OfflineRepositories() : super(username: 'Sonykhan1121');
  @override
  Future<List<RepositoryItem>> fetchPublicRepositories({
    required List<RepositoryItem> fallbackRepositories,
  }) async => fallbackRepositories;
}

Future<void> _decode(WidgetTester tester, String asset) async {
  await tester.runAsync(
    () => precacheImage(AssetImage(asset), tester.element(find.byType(Dialog))),
  );
  await _finishTransition(tester);
}

// The full portfolio has ongoing decorative animations. Settle only the
// interaction's bounded transition instead of waiting for the whole app to idle.
Future<void> _finishTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 800));
  await tester.pump();
}

IconButton _arrow(WidgetTester tester, String tooltip) =>
    tester.widget<IconButton>(
      find.byWidgetPredicate(
        (widget) => widget is IconButton && widget.tooltip == tooltip,
      ),
    );

void _checkSideArrowLayout(WidgetTester tester) {
  final stage = tester.getRect(
    find.byKey(const ValueKey('screenshot-viewer-stage')),
  );
  final image = tester.getRect(find.byType(InteractiveViewer));
  final left = find.byKey(const ValueKey('screenshot-side-previous'));
  final right = find.byKey(const ValueKey('screenshot-side-next'));
  final leftRect = tester.getRect(left);
  final rightRect = tester.getRect(right);
  expect(leftRect.center.dy, closeTo(stage.center.dy, 0.1));
  expect(rightRect.center.dy, closeTo(stage.center.dy, 0.1));
  expect(leftRect.right, lessThanOrEqualTo(image.left));
  expect(rightRect.left, greaterThanOrEqualTo(image.right));
  expect(leftRect.width, greaterThanOrEqualTo(48));
  expect(rightRect.height, greaterThanOrEqualTo(48));
  // Zooming/panning the screenshot cannot move the navigation controls.
  expect(
    find.ancestor(of: left, matching: find.byType(InteractiveViewer)),
    findsNothing,
  );
  expect(
    find.ancestor(of: right, matching: find.byType(InteractiveViewer)),
    findsNothing,
  );
  expect(find.byTooltip('Previous image'), findsOneWidget);
  expect(find.byTooltip('Next image'), findsOneWidget);
}

void main() {
  testWidgets(
    'six independent galleries browse all images without opening repositories',
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
      await tester.pumpWidget(
        PortfolioApp(repositoryService: _OfflineRepositories()),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName.contains('/gallery-'),
        ),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('project-gallery:Face Recognition')),
        findsOneWidget,
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      for (final project in featuredProjects) {
        final button = find.byKey(ValueKey('project-gallery:${project.title}'));
        await Scrollable.ensureVisible(tester.element(button), alignment: 0.5);
        final card = find.byWidgetPredicate(
          (widget) =>
              widget is ProjectHoverPreview && widget.title == project.title,
        );
        await mouse.moveTo(tester.getCenter(card));
        await tester.pump(const Duration(milliseconds: 200));
        await tester.runAsync(
          () => precacheImage(
            AssetImage(project.previewAsset!),
            tester.element(card),
          ),
        );
        await _finishTransition(tester);
        await mouse.moveTo(tester.getCenter(button));
        await tester.pump(const Duration(milliseconds: 200));
        expect(
          find.byKey(ValueKey('preview-ready:${project.title}')),
          findsOneWidget,
        );
        await mouse.down(tester.getCenter(button));
        await mouse.up();
        await tester.pump();
        await _decode(tester, project.screenshots.first.$2);
        expect(find.byType(Dialog), findsOneWidget);
        _checkSideArrowLayout(tester);
        expect(launched, isEmpty);
        expect(
          tester
              .widget<IconButton>(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is IconButton &&
                      widget.tooltip == 'Previous image',
                ),
              )
              .onPressed,
          isNull,
        );
        for (var i = 0; i < project.screenshots.length; i++) {
          final current = project.screenshots[i];
          expect(
            _arrow(tester, 'Previous screenshot').onPressed != null,
            i > 0,
          );
          expect(
            _arrow(tester, 'Next screenshot').onPressed != null,
            i < project.screenshots.length - 1,
          );
          expect(
            find.text(
              '${project.title} · ${current.$1} · ${i + 1}/${project.screenshots.length}',
            ),
            findsOneWidget,
          );
          final image = find.descendant(
            of: find.byType(Dialog),
            matching: find.byType(ProgressiveAssetImage),
          );
          expect(image, findsOneWidget);
          expect(tester.widget<ProgressiveAssetImage>(image).asset, current.$2);
          if (i < project.screenshots.length - 1) {
            await tester.tap(
              find.byTooltip(i.isEven ? 'Next screenshot' : 'Next image'),
            );
            await tester.pump();
            await _decode(tester, project.screenshots[i + 1].$2);
          }
        }
        expect(
          tester
              .widget<IconButton>(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is IconButton && widget.tooltip == 'Next image',
                ),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.byTooltip('Previous screenshot'));
        await _decode(
          tester,
          project.screenshots[project.screenshots.length - 2].$2,
        );
        expect(
          find.text(
            '${project.screenshots.length - 1} / ${project.screenshots.length}',
          ),
          findsOneWidget,
        );
        await tester.tap(find.byTooltip('Next image'));
        await _finishTransition(tester);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await _finishTransition(tester);
        expect(
          find.text(
            '${project.screenshots.length - 1} / ${project.screenshots.length}',
          ),
          findsOneWidget,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await _finishTransition(tester);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await _finishTransition(tester);
        expect(find.byType(Dialog), findsNothing);
        expect(launched, isEmpty);
        expect(tester.takeException(), isNull, reason: project.title);
        await mouse.moveTo(Offset.zero);
      }
      await mouse.removePointer();
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'gallery fits phone landscape and enlarged text; keyboard focus returns to Preview',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final setting in [
        (const Size(360, 780), 1.0),
        (const Size(320, 640), 1.0),
        (const Size(780, 360), 1.0),
        (const Size(390, 844), 2.0),
      ]) {
        tester.view.physicalSize = setting.$1;
        await tester.pumpWidget(
          MaterialApp(
            builder:
                (context, child) => MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.linear(setting.$2)),
                  child: child!,
                ),
            home: Scaffold(
              body: Builder(
                builder:
                    (context) => TextButton(
                      autofocus: true,
                      onPressed:
                          () => showProjectScreenshots(
                            context: context,
                            title: 'Hand Gesture Detector',
                            screenshots: featuredProjects[1].screenshots,
                          ),
                      child: const Text('Preview'),
                    ),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pump();
        await _decode(tester, featuredProjects[1].screenshots.first.$2);
        expect(find.byType(Dialog), findsOneWidget);
        _checkSideArrowLayout(tester);
        await tester.tap(find.byTooltip('Next screenshot'));
        await _decode(tester, featuredProjects[1].screenshots[1].$2);
        expect(find.text('2 / 15'), findsOneWidget);
        await tester.tap(find.byTooltip('Previous screenshot'));
        await _decode(tester, featuredProjects[1].screenshots.first.$2);
        expect(find.text('1 / 15'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byTooltip('Close screenshot viewer'));
        await _finishTransition(tester);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await _finishTransition(tester);
        expect(find.byType(Dialog), findsOneWidget);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await _finishTransition(tester);
        await tester.pumpWidget(const SizedBox());
      }
    },
  );
}
