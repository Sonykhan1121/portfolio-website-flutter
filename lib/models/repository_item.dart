import 'package:flutter/material.dart';

class RepositoryItem {
  const RepositoryItem({
    required this.name,
    required this.description,
    required this.language,
    required this.url,
    required this.updated,
    required this.category,
  });

  final String name;
  final String description;
  final String language;
  final String url;
  final String updated;
  final String category;
}

class FeaturedProject {
  const FeaturedProject({
    required this.title,
    required this.kicker,
    required this.description,
    required this.tags,
    required this.icon,
    required this.url,
    required this.colors,
  });

  final String title;
  final String kicker;
  final String description;
  final List<String> tags;
  final IconData icon;
  final String url;
  final List<int> colors;
}
