import 'repository_item.dart';

enum RepositorySort { relevant, newest, starred }

/// One query powers the results and counts, without mutating the synced list.
List<RepositoryItem> queryRepositories(
  List<RepositoryItem> repositories, {
  String query = '',
  String language = 'All',
  bool featuredOnly = false,
  Set<String> featuredUrls = const {},
  RepositorySort sort = RepositorySort.relevant,
}) {
  final normalized = query.trim().toLowerCase();
  bool featured(RepositoryItem repo) =>
      featuredUrls.contains(repo.url.toLowerCase());
  int relevance(RepositoryItem repo) {
    final name = repo.name.toLowerCase();
    return (normalized.isNotEmpty && name == normalized ? 100 : 0) +
        (normalized.isNotEmpty && name.contains(normalized) ? 20 : 0) +
        (featured(repo) ? 10 : 0) +
        (repo.language == 'Dart' ? 2 : 0);
  }

  final result =
      repositories.where((repo) {
        final searchable =
            '${repo.name} ${repo.description} ${repo.language} ${repo.category}'
                .toLowerCase();
        return (language == 'All' || repo.language == language) &&
            (!featuredOnly || featured(repo)) &&
            (normalized.isEmpty || searchable.contains(normalized));
      }).toList();
  result.sort((a, b) {
    final comparison = switch (sort) {
      RepositorySort.relevant => relevance(b).compareTo(relevance(a)),
      RepositorySort.newest => (b.createdAt ?? b.updatedAt ?? DateTime(1970))
          .compareTo(a.createdAt ?? a.updatedAt ?? DateTime(1970)),
      RepositorySort.starred => (b.stars ?? -1).compareTo(a.stars ?? -1),
    };
    if (comparison != 0) return comparison;
    final recent = (b.updatedAt ?? DateTime(1970)).compareTo(
      a.updatedAt ?? DateTime(1970),
    );
    return recent != 0
        ? recent
        : a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return result;
}
