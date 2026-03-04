import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
// Custom Skill Item Widget with Animations
class SkillItem extends StatefulWidget {
  final String text;
  final bool isHovered;
  final bool isMobile;
  final int delay;

  const SkillItem({super.key,
    required this.text,
    required this.isHovered,
    required this.isMobile,
    required this.delay,
  });

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem>
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
  void didUpdateWidget(SkillItem oldWidget) {
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
