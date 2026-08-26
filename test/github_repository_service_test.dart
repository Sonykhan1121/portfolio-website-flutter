import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:portfolio_website_flutter/models/repository_item.dart';
import 'package:portfolio_website_flutter/services/github_repository_service.dart';

void main() {
  test('maps public GitHub repositories and preserves curated copy', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'api.github.com');
      expect(request.url.path, '/users/Sonykhan1121/repos');
      expect(request.url.queryParameters['per_page'], '100');
      return http.Response(
        '''
        [
          {
            "name": "known-project",
            "description": "GitHub description",
            "language": "Dart",
            "html_url": "https://github.com/Sonykhan1121/known-project",
            "updated_at": "2026-08-24T10:00:00Z",
            "topics": ["flutter"],
            "fork": false,
            "archived": false
          },
          {
            "name": "new-api-project",
            "description": "A newly published API project",
            "language": "TypeScript",
            "html_url": "https://github.com/Sonykhan1121/new-api-project",
            "updated_at": "2026-08-25T10:00:00Z",
            "topics": ["api"],
            "fork": false,
            "archived": false
          }
        ]
        ''',
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final service = GitHubRepositoryService(
      username: 'Sonykhan1121',
      client: client,
    );
    const fallback = RepositoryItem(
      name: 'known-project',
      description: 'Curated portfolio description',
      language: 'Dart',
      url: 'https://github.com/Sonykhan1121/known-project',
      updated: 'Jul 2026',
      category: 'Package',
    );

    final repositories = await service.fetchPublicRepositories(
      fallbackRepositories: const [fallback],
    );

    expect(repositories, hasLength(2));
    expect(repositories.first.description, 'Curated portfolio description');
    expect(repositories.first.updated, 'Aug 2026');
    expect(repositories.last.name, 'new-api-project');
    expect(repositories.last.language, 'TypeScript');
    expect(repositories.last.description, 'A newly published API project');
  });

  test('throws a readable exception when GitHub is unavailable', () async {
    final service = GitHubRepositoryService(
      username: 'Sonykhan1121',
      client: MockClient((_) async => http.Response('rate limited', 403)),
    );

    expect(
      service.fetchPublicRepositories(fallbackRepositories: const []),
      throwsA(isA<GitHubRepositoryException>()),
    );
  });
}
