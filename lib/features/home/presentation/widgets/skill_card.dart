import 'package:flutter/material.dart';
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
                      child: _SkillItem(
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

// Custom Skill Item Widget with Animations
class _SkillItem extends StatefulWidget {
  final String text;
  final bool isHovered;
  final bool isMobile;
  final int delay;

  const _SkillItem({
    required this.text,
    required this.isHovered,
    required this.isMobile,
    required this.delay,
  });

  @override
  State<_SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<_SkillItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_SkillItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHovered && !oldWidget.isHovered) {
      Future.delayed(Duration(milliseconds: widget.delay * 50), () {
        if (mounted) _animationController.forward();
      });
    } else if (!widget.isHovered && oldWidget.isHovered) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.95, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isHovered
                  ? DColors.primaryLight
                  : DColors.primaryLight.withValues(alpha: 0.6),
              boxShadow: widget.isHovered
                  ? [
                      BoxShadow(
                        color: DColors.primaryLight.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
          ),
          SizedBox(width: widget.isMobile ? 10 : 12),
          Expanded(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.isMobile ? 13 : 14,
                fontWeight: FontWeight.w500,
                color: widget.isHovered
                    ? DColors.primaryLight
                    : Colors.black.withValues(alpha: 0.7),
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
