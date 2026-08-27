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

class ProjectDemo {
  const ProjectDemo({
    required this.title,
    required this.kicker,
    required this.description,
    required this.duration,
    required this.thumbnail,
    required this.url,
    required this.tags,
    this.thumbnailAlignment = Alignment.center,
  });

  final String title;
  final String kicker;
  final String description;
  final String duration;
  final String thumbnail;
  final String url;
  final List<String> tags;
  final Alignment thumbnailAlignment;
}

class TeamMember {
  const TeamMember({
    required this.name,
    required this.role,
    required this.image,
  });

  final String name;
  final String role;
  final String image;
}
