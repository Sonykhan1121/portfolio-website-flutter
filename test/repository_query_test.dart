import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_website_flutter/models/repository_item.dart';
import 'package:portfolio_website_flutter/models/repository_query.dart';

void main() {
  final repos = [
    RepositoryItem(
      name: 'flutter-kit',
      description: 'Mobile tools',
      language: 'Dart',
      url: 'https://github.com/user/flutter-kit',
      updated: 'Jan 2025',
      category: 'Package',
      stars: 15,
      createdAt: DateTime(2024),
      updatedAt: DateTime(2025),
    ),
    RepositoryItem(
      name: 'fresh-api',
      description: 'Flutter companion API',
      language: 'Java',
      url: 'https://github.com/user/fresh-api',
      updated: 'Jan 2026',
      category: 'Backend',
      stars: 2,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    ),
    const RepositoryItem(
      name: 'legacy',
      description: 'Practice',
      language: 'Dart',
      url: 'https://github.com/user/legacy',
      updated: 'Unknown',
      category: 'Learning',
    ),
  ];
  const featured = {'https://github.com/user/flutter-kit'};

  test('newest uses creation dates and places missing dates last', () {
    expect(
      queryRepositories(repos, sort: RepositorySort.newest).map((r) => r.name),
      ['fresh-api', 'flutter-kit', 'legacy'],
    );
    expect(repos.first.name, 'flutter-kit');
  });
  test('stars are numeric and unknown counts sort after known counts', () {
    expect(
      queryRepositories(repos, sort: RepositorySort.starred).map((r) => r.name),
      ['flutter-kit', 'fresh-api', 'legacy'],
    );
  });
  test('search, language and featured filters compose', () {
    expect(
      queryRepositories(
        repos,
        query: ' FLUTTER ',
        language: 'Dart',
        featuredOnly: true,
        featuredUrls: featured,
      ).map((r) => r.name),
      ['flutter-kit'],
    );
    expect(
      queryRepositories(
        repos,
        language: 'Java',
        featuredOnly: true,
        featuredUrls: featured,
      ),
      isEmpty,
    );
  });
  test('relevance prioritizes an exact name over a featured project', () {
    expect(
      queryRepositories(
        repos,
        query: 'fresh-api',
        featuredUrls: featured,
      ).single.name,
      'fresh-api',
    );
    expect(
      queryRepositories(repos, featuredUrls: featured).first.name,
      'flutter-kit',
    );
  });
}
