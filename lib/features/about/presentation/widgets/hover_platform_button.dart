import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class HoverPlatformButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final double height;
  final double fontSize;

  const HoverPlatformButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.height,
    required this.fontSize,
  });

  @override
  State<HoverPlatformButton> createState() => _HoverPlatformButtonState();
}

class _HoverPlatformButtonState extends State<HoverPlatformButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _lift;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _lift = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
    _glow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hoverCtrl.forward(),
      onExit: (_) => _hoverCtrl.reverse(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _hoverCtrl,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, _lift.value),
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: DColors.primaryDark.withValues(
                    alpha: 0.12 + 0.18 * _glow.value,
                  ),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: DColors.primaryDark.withValues(
                      alpha: 0.06 + 0.14 * _glow.value,
                    ),
                    blurRadius: 8 + 14 * _glow.value,
                    offset: Offset(0, 3 + 4 * _glow.value),
                  ),
                ],
              ),
              child: child,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                  color: DColors.primaryDark,
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