import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/skills/presentation/widgets/skill_item.dart';
import '../../../../core/constants/colors.dart';

class SkillCard extends StatefulWidget {
  final String icon;
  final String title;
  final List<String> listOfSubTitle;

  const SkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.listOfSubTitle,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isMobile ? 18 : 24),
            margin: EdgeInsets.all(isMobile ? 12 : 16),
            decoration: BoxDecoration(
              color: _isHovered
                  ? DColors.primaryLight.withValues(alpha: 0.02)
                  : DColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1.5,
                color: _isHovered
                    ? DColors.primaryLight.withValues(alpha: 0.8)
                    : DColors.primaryLight.withValues(alpha: 0.4),
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: DColors.primaryLight.withValues(alpha: 0.15),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: DColors.primaryLight.withValues(alpha: 0.08),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: DColors.primaryLight.withValues(alpha: 0.08),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Icon and Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? DColors.primaryLight.withValues(alpha: 0.12)
                            : DColors.primaryLight.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isHovered
                              ? DColors.primaryLight.withValues(alpha: 0.4)
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.all(isMobile ? 12 : 14),
                      child: AnimatedScale(
                        scale: _isHovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Image.asset(
                          widget.icon,
                          height: isMobile ? 22 : 26,
                          width: isMobile ? 22 : 26,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: isMobile ? 14 : 16),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.w800,
                              color: DColors.primaryDark,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 2,
                            width: _isHovered ? 40 : 30,
                            decoration: BoxDecoration(
                              color: DColors.primaryLight,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 18 : 24),
                // Skills List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.listOfSubTitle.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < widget.listOfSubTitle.length - 1
                            ? (isMobile ? 10 : 12)
                            : 0,
                      ),
                      child: SkillItem(
                        text: widget.listOfSubTitle[index],
                        isHovered: _isHovered,
                        isMobile: isMobile,
                        delay: index,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

