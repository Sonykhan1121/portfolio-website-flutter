import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  testWidgets(
    'education card opens the official university from text and keyboard',
    (tester) async {
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
      for (final width in [1440.0, 390.0, 360.0]) {
        tester.view.physicalSize = Size(width, 1000);
        await tester.pumpWidget(
          PortfolioApp(repositoryService: _OfflineRepositories()),
        );
        await tester.pump(const Duration(milliseconds: 100));
        const degree = 'BSc in Computer Science & Engineering';
        const university =
            'Daffodil International University • CGPA 3.82 / 4.00';
        expect(find.text('2018 — 2023'), findsOneWidget);
        expect(find.text(university), findsOneWidget);
        final semantics = tester.widget<Semantics>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics &&
                (widget.properties.label?.startsWith(
                      'Visit university website.',
                    ) ??
                    false),
          ),
        );
        expect(semantics.properties.link, isTrue);
        expect(semantics.properties.button, isFalse);
        expect(semantics.properties.label, contains('Opens in a new tab.'));
        for (final label in [degree, university, 'Visit university website']) {
          final target = find.text(label);
          await Scrollable.ensureVisible(
            tester.element(target),
            alignment: 0.5,
          );
          await tester.pump();
          await tester.tap(target);
          await tester.pump();
          expect(launched.last, 'https://daffodilvarsity.edu.bd/');
        }
        final title = find.text(degree);
        await Scrollable.ensureVisible(tester.element(title), alignment: 0.5);
        Focus.of(tester.element(title)).requestFocus();
        await tester.pump();
        for (final key in [
          LogicalKeyboardKey.enter,
          LogicalKeyboardKey.space,
        ]) {
          final count = launched.length;
          await tester.sendKeyEvent(key);
          await tester.pump();
          expect(launched.length, count + 1);
          expect(launched.last, 'https://daffodilvarsity.edu.bd/');
        }
        expect(find.text('Explore THT-Space journey'), findsOneWidget);
        expect(
          tester.takeException(),
          isNull,
          reason: '$width px education card',
        );
        await tester.pumpWidget(const SizedBox.shrink());
      }
      expect(launched, List.filled(15, 'https://daffodilvarsity.edu.bd/'));
    },
  );

  testWidgets('education link fits a narrow phone and enlarged text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1440, 1000);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      PortfolioApp(repositoryService: _OfflineRepositories()),
    );
    await tester.pump(const Duration(milliseconds: 100));
    final label = find.text('Visit university website');
    final theme = Theme.of(tester.element(label));
    final card = tester.widget<Material>(
      find.ancestor(of: label, matching: find.byType(Material)).first,
    );
    for (final scale in [1.0, 2.0]) {
      tester.view.physicalSize = const Size(320, 900);
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          builder:
              (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(scale)),
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
      expect(find.text('Visit university website'), findsOneWidget);
      expect(
        tester.takeException(),
        isNull,
        reason: '320px education card at ${scale}x',
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
  });

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
      'Sharing knowledge in Bengali',
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
