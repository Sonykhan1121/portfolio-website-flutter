import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/skills/presentation/widgets/skill_card.dart';
import '../../../../core/constants/sizes.dart';

class SkillsSection extends StatelessWidget {
  final List<Map<String, dynamic>> skills;

  const SkillsSection({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive grid configuration based on screen type
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;
    final mainAxisExtent = isMobile ? 380.0 : isTablet ? 420.0 : 450.0;
    final spacing = isMobile ? 16.0 : isTablet ? 20.0 : 24.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: context.verticalPadding,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: skills.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          mainAxisExtent: mainAxisExtent,
        ),
        itemBuilder: (context, index) {
          final Map<String, dynamic> skill = skills[index];

          return SkillCard(
            icon: skill['icon'] as String,
            title: skill['title'] as String,
            listOfSubTitle: List<String>.from(skill['listOfSubTitle']),
          );
        },
      ),
    );
  }
}