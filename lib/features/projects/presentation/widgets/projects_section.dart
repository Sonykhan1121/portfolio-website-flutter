import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/project_detail_page.dart';
import '../../../../core/constants/sizes.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  final List<Map<String, dynamic>> projects;

  const ProjectsSection({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive grid configuration based on screen type
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 2;
    final mainAxisExtent = isMobile ? 420.0 : isTablet ? 460.0 : 480.0;
    final spacing = isMobile ? 16.0 : isTablet ? 20.0 : 24.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: context.horizontalPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          mainAxisExtent: mainAxisExtent,
        ),
        itemBuilder: (context, index) {
          final Map<String, dynamic> project = projects[index];

          return ProjectCard(
            title: project['title'] as String,
            listOfTopics: List<String>.from(project['listOfTopics']),
            description: project['description'] as String,
            url: project['url'] as String,
            projectImagePreview: project['projectImagePreview'],
            projectData: project,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjectDetailPage(project: project),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

