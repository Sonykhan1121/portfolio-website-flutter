import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class ProjectTopic extends StatelessWidget {
  final List<String> topics;

  const ProjectTopic({super.key, required this.topics});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...topics.map(
          (t) => Chip(
            padding: EdgeInsets.all(4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            label: Text(t, style: TextStyle(color: DColors.primaryLight)),
            backgroundColor: DColors.primaryLight.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}
