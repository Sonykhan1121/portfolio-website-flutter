import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A pointer-only, non-interactive cover above the original card link.
/// The optional gallery action remains independently tappable and focusable.
class ProjectHoverPreview extends StatefulWidget {
  const ProjectHoverPreview({
    super.key,
    required this.title,
    required this.linkLabel,
    required this.accent,
    required this.child,
    this.asset,
    this.code,
    this.label = 'APP SCREENSHOT',
    this.action,
  });

  final String title;
  final String linkLabel;
  final Color accent;
  final Widget child;
  final String? asset;
  final String? code;
  final String label;

  /// Kept above the non-interactive preview, outside the card link semantics.
  final Widget? action;

  @override
  State<ProjectHoverPreview> createState() => _ProjectHoverPreviewState();
}

class _ProjectHoverPreviewState extends State<ProjectHoverPreview>
    with WidgetsBindingObserver {
  Timer? _intent;
  bool _inside = false;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _enter(PointerEnterEvent event) {
    if (event.kind != PointerDeviceKind.mouse || _inside) return;
    _inside = true;
    HardwareKeyboard.instance.addHandler(_handleKey);
    _intent = Timer(const Duration(milliseconds: 160), () {
      if (mounted && _inside) setState(() => _showPreview = true);
    });
  }

  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _intent?.cancel();
      if (_showPreview) setState(() => _showPreview = false);
      // Let the parent process Escape as well, if it has its own shortcut.
    }
    return false;
  }

  void _leave() {
    _intent?.cancel();
    if (_inside) HardwareKeyboard.instance.removeHandler(_handleKey);
    _inside = false;
    if (_showPreview) setState(() => _showPreview = false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) _leave();
  }

  @override
  void dispose() {
    _intent?.cancel();
    if (_inside) HardwareKeyboard.instance.removeHandler(_handleKey);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _surface(Widget content) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('preview-ready:${widget.title}'),
      tween: Tween(begin: 0, end: 1),
      duration:
          MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 180),
      builder:
          (context, opacity, child) => Opacity(opacity: opacity, child: child),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: widget.accent.withValues(alpha: 0.4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Color(0xFF5E6B7D),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: content,
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 12),
              padding: EdgeInsets.fromLTRB(
                18,
                12,
                widget.action == null ? 18 : 136,
                14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          widget.linkLabel,
                          style: const TextStyle(
                            color: Color(0xFF087F6B),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.action == null)
                    const Icon(
                      Icons.open_in_new_rounded,
                      color: Color(0xFF087F6B),
                      size: 18,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asset == null && widget.code == null && widget.action == null) {
      return widget.child;
    }
    return MouseRegion(
      onEnter: _enter,
      onExit: (_) => _leave(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_showPreview && (widget.asset != null || widget.code != null))
            Positioned.fill(
              child: IgnorePointer(
                child: ExcludeSemantics(
                  child:
                      widget.asset != null
                          ? Image.asset(
                            widget.asset!,
                            fit: BoxFit.contain,
                            // Created only after deliberate hover. Until decode
                            // succeeds, the original card remains fully visible.
                            frameBuilder:
                                (context, image, frame, synchronous) =>
                                    frame == null
                                        ? const SizedBox.shrink()
                                        : _surface(image),
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const SizedBox.shrink(),
                          )
                          : _surface(
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF142137),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.code!,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    color: Color(0xFFD9F8EE),
                                    fontSize: 13,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                ),
              ),
            ),
          if (widget.action != null)
            Positioned(right: 18, bottom: 18, child: widget.action!),
        ],
      ),
    );
  }
}
