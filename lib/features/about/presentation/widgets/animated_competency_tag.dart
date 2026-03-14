import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class AnimatedCompetencyTag extends StatefulWidget {
  final String label;
  final int index;
  final double fontSize;
  const AnimatedCompetencyTag({
    required this.label,
    required this.index,
    required this.fontSize,
  });

  @override
  State<AnimatedCompetencyTag> createState() => _AnimatedCompetencyTagState();
}

class _AnimatedCompetencyTagState extends State<AnimatedCompetencyTag>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _scale;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
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
      child: AnimatedBuilder(
        animation: _hoverCtrl,
        builder: (_, __) => Transform.scale(
          scale: _scale.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: DColors.primaryDark.withValues(
                alpha: 0.05 + 0.07 * _glow.value,
              ),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: DColors.primaryDark.withValues(
                  alpha: 0.15 + 0.25 * _glow.value,
                ),
                width: 1.5,
              ),
              boxShadow: _glow.value > 0
                  ? [
                BoxShadow(
                  color: DColors.primaryDark.withValues(
                    alpha: 0.10 * _glow.value,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
                  : null,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
                color: DColors.primaryDark,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}