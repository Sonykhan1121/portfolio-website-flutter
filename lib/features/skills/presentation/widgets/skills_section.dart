// ─── skills_section.dart ──────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/skills/presentation/widgets/skill_card.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/colors.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';

class SkillsSection extends StatefulWidget {
  final List<Map<String, dynamic>> skills;
  const SkillsSection({super.key, required this.skills});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOutCubic)),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Distinct gradient pairs per card index
  static const List<List<Color>> _cardGradients = [
    [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Indigo → Violet
    [Color(0xFF0EA5E9), Color(0xFF06B6D4)], // Sky → Cyan
    [Color(0xFF10B981), Color(0xFF34D399)], // Emerald → Green
    [Color(0xFFF59E0B), Color(0xFFFB923C)], // Amber → Orange
    [Color(0xFFEC4899), Color(0xFFF43F5E)], // Pink → Rose
    [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Violet → Indigo
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;
    final crossAxisCount = isMobile ? 1 : isTablet ? 2 : 3;
    final spacing = isMobile ? 20.0 : 24.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: context.verticalPadding,
      ),
      child: Column(
        children: [

          // ── Cards grid ─────────────────────────────────────────
          isMobile
              ? Column(
            children: List.generate(widget.skills.length, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: _buildCard(i),
              );
            }),
          )
              : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.skills.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              mainAxisExtent: isTablet ? 400.0 : 420.0,
            ),
            itemBuilder: (_, i) => _buildCard(i),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int i) {
    final skill = widget.skills[i];
    final gradient = _cardGradients[i % _cardGradients.length];
    return SkillCard(
      icon: skill['icon'] as String,
      title: skill['title'] as String,
      listOfSubTitle: List<String>.from(skill['listOfSubTitle']),
      accentColors: gradient,
      entryDelay: Duration(milliseconds: 120 * i),
    );
  }
}