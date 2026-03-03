import 'package:flutter/material.dart';
import '../widgets/number_with_title.dart';
import '../widgets/projects_section.dart';

class SectionFour extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> projects;
  const SectionFour({super.key,required this.isMobile,required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "03", title: "Featured Projects"),
        SizedBox(height: 20,),
        ProjectsSection(isMobile: isMobile, projects: projects),
      ],
    );
  }
}
