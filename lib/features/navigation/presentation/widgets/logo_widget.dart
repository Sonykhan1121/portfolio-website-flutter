import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class LogoWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  const LogoWidget({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedScale(
          scale: _isHovered ? 1.12 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '<',
                  style: TextStyle(
                    color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                TextSpan(
                  text: widget.text,
                  style: TextStyle(
                    color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: '/>',
                  style: TextStyle(
                    color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
