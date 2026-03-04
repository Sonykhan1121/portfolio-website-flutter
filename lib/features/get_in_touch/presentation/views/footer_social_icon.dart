import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
// Footer Social Icon Widget
class FooterSocialIcon extends StatefulWidget {
  final String assetPath;
  final String tooltip;
  final VoidCallback onTap;

  const FooterSocialIcon({
    required this.assetPath,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<FooterSocialIcon> createState() => _FooterSocialIconState();
}

class _FooterSocialIconState extends State<FooterSocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isHovered ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: DColors.primaryDark.withValues(
                      alpha: _isHovered ? 0.2 : 0.1,
                    ),
                    blurRadius: _isHovered ? 10 : 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.assetPath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}