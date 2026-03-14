// ─── project_card.dart ────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../intro/data/services/url_launcher_service.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/project_topic.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> listOfTopics;
  final String url;
  final String? projectImagePreview;
  final Map<String, dynamic>? projectData;
  final VoidCallback? onTap;
  final List<Color> accentColors;
  final Duration entryDelay;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.listOfTopics,
    required this.url,
    this.projectImagePreview,
    this.projectData,
    this.onTap,
    required this.accentColors,
    this.entryDelay = Duration.zero,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with TickerProviderStateMixin {
  bool _isHovered = false;

  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;
  late Animation<Offset> _entrySlide;

  late AnimationController _hoverCtrl;
  late Animation<double> _hoverT;

  Color get _c1 => widget.accentColors[0];
  Color get _c2 => widget.accentColors[1];

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _entryFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _entrySlide =
        Tween<Offset>(begin: const Offset(0, 0.22), end: Offset.zero)
            .animate(CurvedAnimation(
            parent: _entryCtrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.entryDelay, () {
      if (mounted) _entryCtrl.forward();
    });

    _hoverCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _hoverT =
        CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _hoverT,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, -6 * _hoverT.value),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Color.lerp(
                        Colors.grey.withValues(alpha: 0.13),
                        _c1.withValues(alpha: 0.45),
                        _hoverT.value,
                      )!,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: _c1.withValues(alpha: 0.18 * _hoverT.value),
                        blurRadius: 32,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image / Preview banner ───────────────────
                  _PreviewBanner(
                    title: widget.title,
                    imagePreview: widget.projectImagePreview,
                    c1: _c1,
                    c2: _c2,
                    hoverT: _hoverT,
                    url: widget.url,
                  ),

                  // ── Body ─────────────────────────────────────
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + action icons
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black.withValues(alpha: 0.88),
                                    letterSpacing: 0.1,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              _IconBtn(
                                assetPath: 'assets/icons/git_tag.png',
                                accent: _c1,
                                hoverT: _hoverT,
                                tooltip: 'GitHub',
                                onTap: () => UrlLauncherService
                                    .launchExternal(widget.url),
                              ),
                              const SizedBox(width: 6),
                              _IconBtn(
                                assetPath: 'assets/icons/open_url.png',
                                accent: _c1,
                                hoverT: _hoverT,
                                tooltip: 'Open',
                                onTap: () => UrlLauncherService
                                    .launchExternal(widget.url),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Animated accent underline
                          AnimatedBuilder(
                            animation: _hoverT,
                            builder: (_, __) => Container(
                              height: 2,
                              width: 24 + 18 * _hoverT.value,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [_c1, _c2]),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Description
                          Expanded(
                            child: Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color:
                                Colors.black.withValues(alpha: 0.58),
                                height: 1.65,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Tech topics
                          _TopicsRow(
                            topics: widget.listOfTopics,
                            c1: _c1,
                            c2: _c2,
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Preview banner
// ─────────────────────────────────────────────────────────────────────────────

class _PreviewBanner extends StatelessWidget {
  final String title;
  final String? imagePreview;
  final Color c1, c2;
  final Animation<double> hoverT;
  final String url;

  const _PreviewBanner({
    required this.title,
    required this.imagePreview,
    required this.c1,
    required this.c2,
    required this.hoverT,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage =
        imagePreview != null && imagePreview!.isNotEmpty;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
      child: AnimatedBuilder(
        animation: hoverT,
        builder: (_, child) => Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: hasImage
                ? null
                : LinearGradient(
              colors: [
                Color.lerp(c1.withValues(alpha: 0.10),
                    c1.withValues(alpha: 0.20), hoverT.value)!,
                Color.lerp(c2.withValues(alpha: 0.06),
                    c2.withValues(alpha: 0.14), hoverT.value)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: child,
        ),
        child: hasImage
            ? Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePreview!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  _FallbackBanner(title: title, c1: c1, c2: c2),
            ),
            // Gradient overlay
            AnimatedBuilder(
              animation: hoverT,
              builder: (_, __) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      c1.withValues(
                          alpha: 0.18 * hoverT.value),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ],
        )
            : _FallbackBanner(title: title, c1: c1, c2: c2),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fallback banner (no image)
// ─────────────────────────────────────────────────────────────────────────────

class _FallbackBanner extends StatelessWidget {
  final String title;
  final Color c1, c2;
  const _FallbackBanner(
      {required this.title, required this.c1, required this.c2});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Decorative circles
        Positioned(
          top: -20,
          right: -20,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c1.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -15,
          left: 10,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c2.withValues(alpha: 0.07),
            ),
          ),
        ),
        // Center content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: c1.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [c1, c2],
                  ).createShader(bounds),
                  child: const Icon(Icons.code_rounded,
                      size: 28, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c1.withValues(alpha: 0.75),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action icon button
// ─────────────────────────────────────────────────────────────────────────────

class _IconBtn extends StatefulWidget {
  final String assetPath;
  final Color accent;
  final Animation<double> hoverT;
  final String tooltip;
  final VoidCallback onTap;

  const _IconBtn({
    required this.assetPath,
    required this.accent,
    required this.hoverT,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _s;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 160));
    _s = Tween<double>(begin: 1.0, end: 1.18)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _c.forward(),
        onExit: (_) => _c.reverse(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _c,
            builder: (_, child) => Transform.scale(
              scale: _s.value,
              child: AnimatedBuilder(
                animation: widget.hoverT,
                builder: (_, __) => Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(
                        alpha: 0.07 * widget.hoverT.value),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: widget.accent.withValues(
                          alpha: 0.25 * widget.hoverT.value),
                      width: 1,
                    ),
                  ),
                  child: Image.asset(widget.assetPath,
                      height: 18, width: 18, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Topics row (pill chips)
// ─────────────────────────────────────────────────────────────────────────────

class _TopicsRow extends StatelessWidget {
  final List<String> topics;
  final Color c1, c2;
  const _TopicsRow(
      {required this.topics, required this.c1, required this.c2});

  @override
  Widget build(BuildContext context) {
    final visible = topics.take(4).toList();
    final overflow = topics.length - visible.length;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...visible.map((t) => Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: c1.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: c1.withValues(alpha: 0.22), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                  LinearGradient(colors: [c1, c2]),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                t,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: c1.withValues(alpha: 0.80),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        )),
        if (overflow > 0)
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: Colors.black.withValues(alpha: 0.10), width: 1),
            ),
            child: Text(
              '+$overflow more',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Colors.black.withValues(alpha: 0.40),
              ),
            ),
          ),
      ],
    );
  }
}