import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/skills/presentation/widgets/top_banner.dart';


class SkillCard extends StatefulWidget {
  final String icon;
  final String title;
  final List<String> listOfSubTitle;
  final List<Color> accentColors;
  final Duration entryDelay;

  const SkillCard({
    super.key,
    required this.icon,
    required this.title,
    required this.listOfSubTitle,
    required this.accentColors,
    this.entryDelay = Duration.zero,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> with TickerProviderStateMixin {
  bool _isHovered = false;

  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;

  late AnimationController _hoverCtrl;
  late Animation<double> _hoverT;

  @override
  void initState() {
    super.initState();

    // Entry
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _entryFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );
    Future.delayed(widget.entryDelay, () {
      if (mounted) _entryCtrl.forward();
    });

    // Hover
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _hoverT = CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _hoverCtrl.dispose();
    super.dispose();
  }

  Color get _accent1 => widget.accentColors[0];
  Color get _accent2 => widget.accentColors[1];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 500;

    return FadeTransition(
      opacity: _entryFade,
      child: SlideTransition(
        position: _entrySlide,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() => _isHovered = true);
            _hoverCtrl.forward();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _hoverCtrl.reverse();
          },
          child: AnimatedBuilder(
            animation: _hoverT,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -5 * _hoverT.value),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color.lerp(
                        Colors.grey.withValues(alpha: 0.15),
                        _accent1.withValues(alpha: 0.5),
                        _hoverT.value,
                      )!,
                      width: 1.5,
                    ),
                    boxShadow: [
                      // Base shadow
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                      // Accent glow on hover
                      BoxShadow(
                        color: _accent1.withValues(alpha: 0.18 * _hoverT.value),
                        blurRadius: 28,
                        spreadRadius: 0,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: child,
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top gradient banner ──────────────────────────
                TopBanner(
                  accent1: _accent1,
                  accent2: _accent2,
                  icon: widget.icon,
                  title: widget.title,
                  hoverT: _hoverT,
                  isMobile: isMobile,
                ),

                // ── Skill items ──────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 18 : 22,
                      isMobile ? 16 : 20,
                      isMobile ? 18 : 22,
                      isMobile ? 18 : 22,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Count badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _accent1.withValues(alpha: 0.09),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                '${widget.listOfSubTitle.length} technologies',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _accent1,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Skill chips
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.listOfSubTitle
                                .asMap()
                                .entries
                                .map((e) => _SkillChip(
                              label: e.value,
                              accent1: _accent1,
                              accent2: _accent2,
                              index: e.key,
                              hoverT: _hoverT,
                            ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// ─────────────────────────────────────────────────────────────────────────────
// Skill chip (replaces SkillItem)
// ─────────────────────────────────────────────────────────────────────────────

class _SkillChip extends StatefulWidget {
  final String label;
  final Color accent1, accent2;
  final int index;
  final Animation<double> hoverT;

  const _SkillChip({
    required this.label,
    required this.accent1,
    required this.accent2,
    required this.index,
    required this.hoverT,
  });

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip>
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