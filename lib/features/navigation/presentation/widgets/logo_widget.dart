import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';

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
    final logoSize = Sizes.h4(context);
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
                    fontSize: logoSize,
                  ),
                ),
                TextSpan(
                  text: widget.text,
                  style: TextStyle(
                    color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: logoSize,
                    letterSpacing: 1.2,
                  ),
                ),
                TextSpan(
                  text: '/>',
                  style: TextStyle(
                    color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: logoSize,
                  ),
                ),
              ],
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: logoSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
