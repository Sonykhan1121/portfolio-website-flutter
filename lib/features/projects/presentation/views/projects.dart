import 'package:flutter/material.dart';
import '../widgets/projects_section.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';
import '../../../../core/constants/sizes.dart';

class Projects extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  const Projects({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "03", title: "Featured Projects"),
        SizedBox(height: context.sectionSpacing),
        ProjectsSection(projects: projects),
      ],
    );
  }
}
