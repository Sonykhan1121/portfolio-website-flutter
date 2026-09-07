import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/data/asset_image_previews.dart';
import 'package:portfolio_website_flutter/models/repository_item.dart';
import 'package:portfolio_website_flutter/portfolio_app.dart';
import 'package:portfolio_website_flutter/services/github_repository_service.dart';
import 'package:portfolio_website_flutter/widgets/progressive_asset_image.dart';

const _thumbnail = 'assets/images/bengali-computer-lessons.jpg';
const _channel = 'https://www.youtube.com/@sidratul15';
const _cardKey = ValueKey('teaching-community-card');

class _OfflineRepositories extends GitHubRepositoryService {
  _OfflineRepositories() : super(username: 'Sonykhan1121');

  @override
  Future<List<RepositoryItem>> fetchPublicRepositories({
    required List<RepositoryItem> fallbackRepositories,
  }) async => fallbackRepositories;
}

Future<void> _home(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1440, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    PortfolioApp(repositoryService: _OfflineRepositories()),
  );
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets(
    'teaching card follows skills, precedes journey, and loads lazily',
    (tester) async {
      await _home(tester);
      final card = find.byKey(_cardKey);
      expect(card, findsOneWidget);
      expect(
        tester.getBottomLeft(find.text('Production delivery')).dy,
        lessThan(tester.getTopLeft(card).dy),
      );
      expect(
        tester.getBottomLeft(card).dy,
        lessThan(tester.getTopLeft(find.text('Professional journey')).dy),
      );
      final image = find.descendant(
        of: card,
        matching: find.byType(ProgressiveAssetImage),
      );
      expect(tester.widget<ProgressiveAssetImage>(image).asset, _thumbnail);
      expect(tester.widget<ProgressiveAssetImage>(image).eager, isFalse);
      expect(assetPreviewBytes(_thumbnail), isNotNull);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == _thumbnail,
        ),
        findsNothing,
      );
      expect(
        find.descendant(of: card, matching: find.textContaining('subscribers')),
        findsNothing,
      );
      expect(
        find.textContaining('Created 18 beginner-friendly video lessons'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('thumbnail, copy and keyboard open the same channel', (
    tester,
  ) async {
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
    await _home(tester);
    final card = find.byKey(_cardKey);
    final semantics = tester.widget<Semantics>(
      find.descendant(
        of: card,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              (widget.properties.label?.startsWith(
                    'Sharing knowledge in Bengali.',
                  ) ??
                  false),
        ),
      ),
    );
    expect(semantics.properties.link, isTrue);
    expect(semantics.properties.button, isFalse);
    expect(semantics.properties.label, contains('Opens in a new tab.'));
    await Scrollable.ensureVisible(tester.element(card), alignment: 0.5);
    await tester.runAsync(
      () => precacheImage(const AssetImage(_thumbnail), tester.element(card)),
    );
    await tester.pump(const Duration(milliseconds: 400));
    for (final target in [
      find.descendant(of: card, matching: find.byType(AspectRatio)),
      find.text('Sharing knowledge in Bengali'),
      find.text('Explore the lessons'),
    ]) {
      await tester.tap(target);
      await tester.pump();
      expect(launched.last, _channel);
    }
    Focus.of(tester.element(find.text('Explore the lessons'))).requestFocus();
    await tester.pump();
    for (final key in [LogicalKeyboardKey.enter, LogicalKeyboardKey.space]) {
      await tester.sendKeyEvent(key);
      await tester.pump();
    }
    expect(launched, List.filled(5, _channel));
    expect(tester.takeException(), isNull);
  });

  testWidgets('teaching card fits phones, tablets, desktop and doubled text', (
    tester,
  ) async {
    await _home(tester);
    final card = tester.widget(find.byKey(_cardKey));
    final theme = Theme.of(tester.element(find.byKey(_cardKey)));
    for (final layout in [
      (320.0, 1.0),
      (390.0, 2.0),
      (768.0, 1.0),
      (1024.0, 1.0),
      (1440.0, 2.0),
    ]) {
      tester.view.physicalSize = Size(layout.$1, 1000);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          builder:
              (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(layout.$2)),
                child: child!,
              ),
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: card,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Explore the lessons'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: '${layout.$1}px at ${layout.$2}x text',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
}
