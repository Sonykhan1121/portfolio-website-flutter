import 'package:flutter/material.dart';
import '../../../../core/constants/break_points.dart';
import 'package:portfolio_website_flutter/features/intro/presentation/widgets/skill_card.dart';

class SkillsSection extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, dynamic>> skills;

  const SkillsSection({
    super.key,
    required this.isMobile,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isTablet = screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;

        // Dynamic grid configuration
        final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;
        final mainAxisExtent = isMobile ? 380.0 : isTablet ? 420.0 : 450.0;
        final crossAxisSpacing = isMobile ? 16.0 : isTablet ? 20.0 : 24.0;
        final mainAxisSpacing = isMobile ? 16.0 : isTablet ? 20.0 : 24.0;
        final padding = isMobile ? 16.0 : 20.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
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
      },
    );
  }
}