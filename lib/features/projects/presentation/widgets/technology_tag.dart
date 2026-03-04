import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';
// Technology Tag Widget
class TechnologyTag extends StatefulWidget {
  final String label;
  final BuildContext context;

  const TechnologyTag({required this.label, required this.context});

  @override
  State<TechnologyTag> createState() => _TechnologyTagState();
}

class _TechnologyTagState extends State<TechnologyTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: context.elementSpacing * 0.7, vertical: context.elementSpacing * 0.4),
        decoration: BoxDecoration(
          color: _isHovered
              ? Colors.blue.withValues(alpha: 0.12)
              : Colors.blue.withValues(alpha: 0.06),
          border: Border.all(
            color: _isHovered
                ? Colors.blue.withValues(alpha: 0.5)
                : Colors.blue.withValues(alpha: 0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: context.competencyFontSize,
            fontWeight: FontWeight.w600,
            color: _isHovered ? Colors.blue.shade700 : Colors.blue.shade600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}