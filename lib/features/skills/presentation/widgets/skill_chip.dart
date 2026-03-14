import 'package:flutter/material.dart';

class SkillChip extends StatefulWidget {
  final String label;
  final Color accent1, accent2;
  final int index;
  final Animation<double> hoverT;

  const SkillChip({
    required this.label,
    required this.accent1,
    required this.accent2,
    required this.index,
    required this.hoverT,
  });

  @override
  State<SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<SkillChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _chipCtrl;
  late Animation<double> _chipFade;

  @override
  void initState() {
    super.initState();
    _chipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _chipFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _chipCtrl, curve: Curves.easeOut),
    );
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _chipCtrl.forward();
    });
  }

  @override
  void dispose() {
    _chipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _chipFade,
      child: AnimatedBuilder(
        animation: widget.hoverT,
        builder: (_, __) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Color.lerp(
              widget.accent1.withValues(alpha: 0.06),
              widget.accent1.withValues(alpha: 0.13),
              widget.hoverT.value,
            ),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: Color.lerp(
                widget.accent1.withValues(alpha: 0.18),
                widget.accent1.withValues(alpha: 0.45),
                widget.hoverT.value,
              )!,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [widget.accent1, widget.accent2],
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: widget.accent1.withValues(alpha: 0.85),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}