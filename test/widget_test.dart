// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
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
  });
}
