// ─── projects_section.dart ────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/project_detail_page.dart';
import '../../../../core/constants/sizes.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/project_card.dart';

class ProjectsSection extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  const ProjectsSection({super.key, required this.projects});

  // Unique accent colors per project card
  static const List<List<Color>> _accents = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
    [Color(0xFF10B981), Color(0xFF34D399)],
    [Color(0xFFF59E0B), Color(0xFFFB923C)],
    [Color(0xFFEC4899), Color(0xFFF43F5E)],
    [Color(0xFF8B5CF6), Color(0xFF6366F1)],
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final crossAxisCount = isMobile ? 1 : 2;
    final spacing = isMobile ? 20.0 : isTablet ? 22.0 : 26.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      child: isMobile
          ? Column(
        children: List.generate(projects.length, (i) => Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: _buildCard(context, i),
        )),
      )
          : GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: projects.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          mainAxisExtent: isTablet ? 460.0 : 480.0,
        ),
        itemBuilder: (_, i) => _buildCard(context, i),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int i) {
    final project = projects[i];
    return ProjectCard(
      title: project['title'] as String,
      description: project['description'] as String,
      listOfTopics: List<String>.from(project['listOfTopics']),
      url: project['url'] as String,
      projectImagePreview: project['projectImagePreview'],
      projectData: project,
      accentColors: _accents[i % _accents.length],
      entryDelay: Duration(milliseconds: 100 * i),
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, anim, __) => ProjectDetailPage(project: project),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
              child: child,
            ),
          ),
          transitionDuration: const Duration(milliseconds: 380),
        ),
      ),
    );
  }
}