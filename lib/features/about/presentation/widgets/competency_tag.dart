import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class CompetencyTag extends StatefulWidget {
  final String label;
  final double fontSize;

  const CompetencyTag({
    required this.label,
    this.fontSize = 13.0,
  });

  @override
  State<CompetencyTag> createState() => _CompetencyTagState();
}

class _CompetencyTagState extends State<CompetencyTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered
              ? DColors.primaryLight.withValues(alpha: 0.15)
              : DColors.primaryLight.withValues(alpha: 0.08),
          border: Border.all(
            color: _isHovered
                ? DColors.primaryLight
                : DColors.primaryLight.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500,
            color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
