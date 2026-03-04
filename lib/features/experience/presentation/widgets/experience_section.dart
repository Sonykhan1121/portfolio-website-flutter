import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/experience/presentation/widgets/timeline_row.dart';

import '../../../../core/constants/colors.dart';
import '../../data/models/experience_model.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const _items = [
    ExperienceItem(
      period: '2025 — Present',
      jobTitle: 'Flutter Developer',
      companyName: 'Tech Company',
      companyLogo: 'assets/icons/facebook_logo.png',
      description:
          'Developing and maintaining cross-platform applications using Flutter '
          'and Dart. Collaborating with design and backend teams to deliver '
          'high-quality user experiences.',
      location: "dhaka",
    ),
    ExperienceItem(
      period: '2024 — 2025',
      jobTitle: 'Junior Flutter Developer',
      companyName: 'Startup Inc.',
      description:
          'Built mobile applications from scratch, implemented state management '
          'patterns, and integrated third-party APIs. Contributed to code '
          'reviews and technical documentation.',
      location: "UK",
      companyLogo: "assets/icons/twitter.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: List.generate(_items.length, (i) {
          final isLast = i == _items.length - 1;
          return TimelineRow(item: _items[i], isLast: isLast);
        }),
      ),
    );
  }
}
