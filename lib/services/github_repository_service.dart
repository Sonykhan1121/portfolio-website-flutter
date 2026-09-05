import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/repository_item.dart';

class GitHubRepositoryService {
  GitHubRepositoryService({
    required this.username,
    Future<String> Function()? repositoryJsonLoader,
  }) : _repositoryJsonLoader =
           repositoryJsonLoader ??
           (() => rootBundle.loadString(_repositoryAssetPath));

  static const _repositoryAssetPath = 'assets/data/github_repositories.json';

  final String username;
  final Future<String> Function() _repositoryJsonLoader;

  Future<List<RepositoryItem>> fetchPublicRepositories({
    required List<RepositoryItem> fallbackRepositories,
  }) async {
    final decoded = jsonDecode(await _repositoryJsonLoader());
    if (decoded is! List) {
      throw const GitHubRepositoryException(
        'The repository snapshot has an unexpected format.',
      );
    }
    final syncedRepositories = decoded.whereType<Map<String, dynamic>>().toList(
      growable: false,
    );

    final curatedByName = {
      for (final repository in fallbackRepositories)
        repository.name.toLowerCase(): repository,
    };

    return syncedRepositories
        .map(
          (repository) => _toRepositoryItem(
            repository,
            curatedByName[repository['name']?.toString().toLowerCase()],
          ),
        )
        .toList(growable: false);
  }

  RepositoryItem _toRepositoryItem(
    Map<String, dynamic> repository,
    RepositoryItem? curated,
  ) {
    final name = repository['name']?.toString().trim() ?? 'Untitled repository';
    final language = _displayLanguage(repository['language']?.toString());
    final liveDescription = repository['description']?.toString().trim();
    final topics =
        (repository['topics'] as List?)
            ?.map((topic) => topic.toString().toLowerCase())
            .toList(growable: false) ??
        const <String>[];
    final isFork = repository['fork'] == true;
    final isArchived = repository['archived'] == true;

    return RepositoryItem(
      name: name,
      description:
          curated?.description ??
          ((liveDescription?.isNotEmpty ?? false)
              ? liveDescription!
              : 'A public $language repository on GitHub.'),
      language:
          language == 'Other' && curated != null ? curated.language : language,
      url:
          repository['html_url']?.toString() ??
          'https://github.com/$username/$name',
      updated: _formatMonthYear(repository['updated_at']?.toString()),
      stars: (repository['stargazers_count'] as num?)?.toInt(),
      createdAt: DateTime.tryParse(repository['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(repository['updated_at']?.toString() ?? ''),
      category:
          curated?.category ??
          _inferCategory(
            name: name,
            language: language,
            topics: topics,
            isFork: isFork,
            isArchived: isArchived,
          ),
    );
  }

  String _displayLanguage(String? value) {
    final language = value?.trim();
    return language == null || language.isEmpty ? 'Other' : language;
  }

  String _formatMonthYear(String? value) {
    final date = DateTime.tryParse(value ?? '');
    if (date == null) return 'Recently updated';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _inferCategory({
    required String name,
    required String language,
    required List<String> topics,
    required bool isFork,
    required bool isArchived,
  }) {
    if (isArchived) return 'Archived';
    if (isFork) return 'Fork';
    if (name.toLowerCase() == username.toLowerCase()) return 'Profile';

    final searchable = '${name.toLowerCase()} ${topics.join(' ')}';
    if (_containsAny(searchable, const ['package', 'plugin', 'library'])) {
      return 'Package';
    }
    if (_containsAny(searchable, const [
      'machine-learning',
      'tflite',
      'face',
    ])) {
      return 'Machine learning';
    }
    if (_containsAny(searchable, const ['algorithm', 'leetcode', 'problem'])) {
      return 'Problem solving';
    }
    if (_containsAny(searchable, const ['portfolio', 'website', 'web'])) {
      return 'Web';
    }
    if (_containsAny(searchable, const ['desktop', 'windows', 'swing'])) {
      return 'Desktop';
    }
    if (_containsAny(searchable, const ['flutter', 'android', 'ios', 'app'])) {
      return 'Mobile app';
    }
    if (_containsAny(searchable, const ['sql', 'database', 'data'])) {
      return 'Data';
    }
    if (language == 'HTML' || language == 'CSS' || language == 'JavaScript') {
      return 'Web';
    }
    return 'Learning';
  }

  bool _containsAny(String value, List<String> terms) {
    return terms.any(value.contains);
  }
}

class GitHubRepositoryException implements Exception {
  const GitHubRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
