import 'package:flutter/material.dart';
import '../widgets/number_with_title.dart';
import '../widgets/skills_section.dart';

class SectionThree extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> skills;
  const SectionThree({super.key,required this.isMobile,required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "02", title: "Skills"),
        SizedBox(height: 40),
        SkillsSection(isMobile:isMobile,skills: skills),
      ],
    );
  }
}
