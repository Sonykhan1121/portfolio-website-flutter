import 'package:flutter/material.dart';
import '../widgets/skills_section.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';
import '../../../../core/constants/sizes.dart';

class Skills extends StatelessWidget {
  final List<Map<String, dynamic>> skills;
  const Skills({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "02", title: "Skills"),
        SizedBox(height: context.sectionSpacing),
        SkillsSection(skills: skills),
      ],
    );
  }
}
