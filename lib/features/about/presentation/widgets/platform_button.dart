import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class PlatformButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final double height;
  final double fontSize;

  const PlatformButton({super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.height = 120.0,
    this.fontSize = 15.0,
  });

  @override
  State<PlatformButton> createState() => _PlatformButtonState();
}

class _PlatformButtonState extends State<PlatformButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? DColors.primaryLight.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? DColors.primaryLight
                  : DColors.primaryColor.withValues(alpha: 0.6),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: DColors.primaryLight.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ]
                : [
              BoxShadow(
                color: DColors.primaryLight.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: widget.icon,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? DColors.primaryLight : DColors.primaryColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}