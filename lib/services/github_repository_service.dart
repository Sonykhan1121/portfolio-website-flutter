import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/repository_item.dart';

class GitHubRepositoryService {
  GitHubRepositoryService({required this.username, http.Client? client})
    : _client = client;

  static const _pageSize = 100;
  static const _requestTimeout = Duration(seconds: 12);

  final String username;
  final http.Client? _client;

  Future<List<RepositoryItem>> fetchPublicRepositories({
    required List<RepositoryItem> fallbackRepositories,
  }) async {
    final client = _client ?? http.Client();
    final liveRepositories = <Map<String, dynamic>>[];

    try {
      var page = 1;
      while (true) {
        final uri = Uri.https('api.github.com', '/users/$username/repos', {
          'type': 'owner',
          'sort': 'updated',
          'direction': 'desc',
          'per_page': '$_pageSize',
          'page': '$page',
        });
        final response = await client
            .get(
              uri,
              headers: const {
                'Accept': 'application/vnd.github+json',
                'X-GitHub-Api-Version': '2022-11-28',
              },
            )
            .timeout(_requestTimeout);

        if (response.statusCode != 200) {
          throw GitHubRepositoryException(
            'GitHub returned status ${response.statusCode}.',
          );
        }

        final decoded = jsonDecode(response.body);
        if (decoded is! List) {
          throw const GitHubRepositoryException(
            'GitHub returned an unexpected response.',
          );
        }

        final pageRepositories =
            decoded.whereType<Map<String, dynamic>>().toList();
        liveRepositories.addAll(pageRepositories);

        if (pageRepositories.length < _pageSize) break;
        page += 1;
      }
    } finally {
      if (_client == null) client.close();
    }

    final curatedByName = {
      for (final repository in fallbackRepositories)
        repository.name.toLowerCase(): repository,
    };

    return liveRepositories
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
