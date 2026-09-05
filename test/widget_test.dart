// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:portfolio_website_flutter/models/repository_item.dart';
import 'package:portfolio_website_flutter/portfolio_app.dart';
import 'package:portfolio_website_flutter/services/github_repository_service.dart';

class _FallbackRepositoryService extends GitHubRepositoryService {
  _FallbackRepositoryService() : super(username: 'Sonykhan1121');

  @override
  Future<List<RepositoryItem>> fetchPublicRepositories({
    required List<RepositoryItem> fallbackRepositories,
  }) async {
    return fallbackRepositories;
  }
}

void main() {
  testWidgets('home stays usable at phone and tablet widths', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final width in [360.0, 390.0, 768.0, 1024.0, 1440.0]) {
      tester.view.physicalSize = Size(width, 844);
      await tester.pumpWidget(
        PortfolioApp(repositoryService: _FallbackRepositoryService()),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester.takeException(),
        isNull,
        reason: 'Layout must fit $width px',
      );
      expect(find.text('Take Off Programming Contest'), findsOneWidget);
      expect(find.text('View profile'), findsNWidgets(4));
    }
  });

  testWidgets('competitive profile cards launch the personal CV links', (
    tester,
  ) async {
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
      PortfolioApp(repositoryService: _FallbackRepositoryService()),
    );
    await tester.pump(const Duration(milliseconds: 100));
    final jump = find.text('Explore my problem-solving journey ↓');
    await Scrollable.ensureVisible(tester.element(jump), alignment: 0.4);
    await tester.tap(jump);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    expect(tester.getTopLeft(find.text('CHAMPION · 2019')).dy, lessThan(1000));
    for (final name in ['Codeforces', 'LeetCode', 'InterviewBit', 'beecrowd']) {
      final card = find.ancestor(
        of: find.text(name),
        matching: find.byType(InkWell),
      );
      await Scrollable.ensureVisible(tester.element(card), alignment: 0.4);
      await tester.tap(card);
      await tester.pump();
    }
    expect(launched, [
      'https://codeforces.com/profile/Ibrahimovic_The_Lion',
      'https://leetcode.com/u/sidratul15-11879/',
      'https://www.interviewbit.com/profile/md-sidratul-montaha-183-15-11879/',
      'https://judge.beecrowd.com/en/profile/294737',
    ]);
    expect(find.text('1200+'), findsOneWidget);
    expect(find.text('187'), findsOneWidget);
    expect(find.text('230+'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('portfolio surfaces production work', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      PortfolioApp(repositoryService: _FallbackRepositoryService()),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Grozziie'), findsWidgets);
    expect(find.textContaining('50K+'), findsWidgets);
    expect(find.text('Explore my work'), findsOneWidget);
    expect(find.text('Explore THT-Space journey'), findsOneWidget);
    expect(
      find.text('One vision at the center.\nEvery specialist in orbit.'),
      findsNothing,
    );
    expect(find.text('See the engineering\nin motion.'), findsOneWidget);
    expect(find.text('Gesture-Controlled Mobile Stand'), findsOneWidget);

    final journeyLink = find.text('Explore THT-Space journey');
    final journeyCard = find.ancestor(
      of: journeyLink,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(journeyCard).onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('THT-SPACE'), findsOneWidget);
    expect(
      find.text('One vision at the center.\nEvery specialist in orbit.'),
      findsOneWidget,
    );
    expect(find.text('Zhang Geng'), findsOneWidget);
    expect(find.text('Zubayar Ahmed'), findsOneWidget);
    expect(find.text('Obaidul Haque'), findsOneWidget);
  });
}
