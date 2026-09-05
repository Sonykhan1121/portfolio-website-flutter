import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/models/repository_item.dart';
import 'package:portfolio_website_flutter/portfolio_app.dart';
import 'package:portfolio_website_flutter/services/github_repository_service.dart';

class _OfflineRepositories extends GitHubRepositoryService {
  _OfflineRepositories() : super(username: 'Sonykhan1121');

  @override
  Future<List<RepositoryItem>> fetchPublicRepositories({
    required List<RepositoryItem> fallbackRepositories,
  }) async => fallbackRepositories;
}

Future<void> _finishScroll(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 750));
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  testWidgets('home and desktop navigation follow the requested order', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      PortfolioApp(repositoryService: _OfflineRepositories()),
    );
    await tester.pump(const Duration(milliseconds: 100));
    var previousTop = double.negativeInfinity;
    for (final heading in [
      'FEATURED RELEASE',
      'SELECTED ENGINEERING WORK',
      'PROJECT DEMOS',
      'COMPETITIVE PROGRAMMING & PROBLEM SOLVING',
      'COMPLETE GITHUB ARCHIVE',
      'ABOUT & CAPABILITIES',
      'Professional journey',
      'AVAILABLE FOR GOOD WORK',
    ]) {
      final top = tester.getTopLeft(find.text(heading)).dy;
      expect(top, greaterThan(previousTop), reason: '$heading is in order');
      previousTop = top;
    }
    expect(
      tester.getTopLeft(find.text('Demos')).dx,
      lessThan(tester.getTopLeft(find.text('Problem solving')).dx),
    );
    expect(find.text('Experience'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop anchors and active state select the requested card', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      PortfolioApp(repositoryService: _OfflineRepositories()),
    );
    await tester.pump(const Duration(milliseconds: 100));
    for (final target in [
      ('Demos', 'PROJECT DEMOS'),
      ('Problem solving', 'COMPETITIVE PROGRAMMING & PROBLEM SOLVING'),
      ('Experience', 'Software Engineer'),
      ('Education', 'BSc in Computer Science & Engineering'),
      ('Experience', 'Software Engineer'),
      ('About', 'ABOUT & CAPABILITIES'),
    ]) {
      final link = find.text(target.$1);
      await tester.tap(link);
      await _finishScroll(tester);
      expect(
        tester.getTopLeft(find.text(target.$2)).dy,
        inInclusiveRange(76, 350),
        reason: '${target.$1} lands below the fixed navigation',
      );
      final selected = find.ancestor(
        of: link,
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.selected == true,
        ),
      );
      expect(selected, findsOneWidget, reason: '${target.$1} is active');
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('mobile menu exposes both journey anchors in page order', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      PortfolioApp(repositoryService: _OfflineRepositories()),
    );
    await tester.pump(const Duration(milliseconds: 100));
    for (final target in [
      ('Experience', 'Software Engineer'),
      ('Education', 'BSc in Computer Science & Engineering'),
    ]) {
      await tester.tap(find.byTooltip('Open navigation'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      final menu = find.byType(BottomSheet);
      final labels =
          tester
              .widgetList<ListTile>(
                find.descendant(of: menu, matching: find.byType(ListTile)),
              )
              .map((tile) => (tile.title! as Text).data)
              .toList();
      expect(labels, [
        'Home',
        'Grozziie',
        'Projects',
        'Demos',
        'Problem solving',
        'Archive',
        'About',
        'Experience',
        'Education',
        'Contact',
      ]);
      final link = find.descendant(of: menu, matching: find.text(target.$1));
      await Scrollable.ensureVisible(tester.element(link));
      await tester.pump();
      await tester.tap(link);
      await _finishScroll(tester);
      expect(find.byType(BottomSheet), findsNothing);
      expect(
        tester.getTopLeft(find.text(target.$2)).dy,
        inInclusiveRange(76, 350),
      );
      expect(find.text(target.$1), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('expanded navigation fits desktop, mobile, and enlarged text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(1440, 1000);
    await tester.pumpWidget(
      PortfolioApp(repositoryService: _OfflineRepositories()),
    );
    await tester.pump(const Duration(milliseconds: 100));
    final navigation = tester.widget(
      find.byKey(const ValueKey('home-navigation')),
    );
    final theme = Theme.of(
      tester.element(find.byKey(const ValueKey('home-navigation'))),
    );
    expect(tester.takeException(), isNull);
    for (final layout in [
      (320.0, 1.0),
      (768.0, 1.0),
      (1344.0, 1.0),
      (1360.0, 1.2),
      (1440.0, 1.0),
      (1440.0, 1.1),
      (1680.0, 1.1),
      (1920.0, 1.0),
      (390.0, 2.0),
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
          home: Scaffold(body: navigation),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(
        tester.takeException(),
        isNull,
        reason: '${layout.$1}px / ${layout.$2}x text',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });
}
