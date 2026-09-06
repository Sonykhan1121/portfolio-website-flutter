import 'package:flutter/material.dart';

import '../data/asset_image_previews.dart';

/// Shows a real-photo preview, then reveals the full image from top to bottom.
/// Image.asset keeps Flutter's normal image cache and the browser/SW HTTP cache.
/// Watching every ancestor scroll position also handles nested screenshot pages.
class ProgressiveAssetImage extends StatefulWidget {
  const ProgressiveAssetImage(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.errorBuilder,
    this.preloadMargin = 200,
    this.eager = false,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double preloadMargin;
  final bool eager;

  @override
  State<ProgressiveAssetImage> createState() => _ProgressiveAssetImageState();
}

class _ProgressiveAssetImageState extends State<ProgressiveAssetImage>
    with WidgetsBindingObserver {
  final _positions = <ScrollPosition>{};
  bool _requested = false;
  bool _checkScheduled = false;
  bool _showPreview = true;

  @override
  void initState() {
    super.initState();
    _requested = widget.eager;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _watchScrollPositions();
    _scheduleVisibilityCheck();
  }

  @override
  void didUpdateWidget(ProgressiveAssetImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) _showPreview = true;
    if (oldWidget.asset != widget.asset || oldWidget.eager != widget.eager) {
      _requested =
          widget.eager || (oldWidget.asset == widget.asset && _requested);
      _watchScrollPositions();
      _scheduleVisibilityCheck();
    }
  }

  void _watchScrollPositions() {
    _stopWatchingScroll();
    if (_requested) return;
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        _positions.add((element.state as ScrollableState).position);
      }
      return true;
    });
    for (final position in _positions) {
      position.addListener(_scheduleVisibilityCheck);
    }
  }

  void _stopWatchingScroll() {
    for (final position in _positions) {
      position.removeListener(_scheduleVisibilityCheck);
    }
    _positions.clear();
  }

  @override
  void didChangeMetrics() => _scheduleVisibilityCheck();

  void _scheduleVisibilityCheck() {
    if (_requested || _checkScheduled || !mounted) return;
    _checkScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (!mounted || _requested) return;
      final box = context.findRenderObject();
      if (box is! RenderBox || !box.attached || !box.hasSize) return;
      final view = View.of(context);
      final viewport = (Offset.zero &
              (view.physicalSize / view.devicePixelRatio))
          .inflate(widget.preloadMargin);
      final bounds = MatrixUtils.transformRect(
        box.getTransformTo(null),
        Offset.zero & box.size,
      );
      if (bounds.overlaps(viewport)) {
        _stopWatchingScroll();
        setState(() => _requested = true);
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopWatchingScroll();
    super.dispose();
  }

  Widget _placeholder({bool failed = false}) => Semantics(
    label:
        widget.semanticLabel == null
            ? null
            : '${widget.semanticLabel}${failed ? ', preview unavailable' : ', loading'}',
    image: true,
    child: SizedBox.expand(
      child: ColoredBox(
        color: const Color(0xFFF2F5F9),
        child: Center(
          child: Icon(
            failed ? Icons.broken_image_outlined : Icons.image_outlined,
            size: 24,
            color: const Color(0xFF8190A4),
          ),
        ),
      ),
    ),
  );

  Widget _preview({bool failed = false}) {
    final bytes = assetPreviewBytes(widget.asset);
    if (bytes == null) return _placeholder(failed: failed);
    return Semantics(
      image: true,
      label:
          widget.semanticLabel == null
              ? null
              : '${widget.semanticLabel}, ${failed ? 'low-resolution preview; full image unavailable' : 'preview; full image loading'}',
      child: Image.memory(
        bytes,
        key: ValueKey('preview:${widget.asset}'),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
        errorBuilder: (_, __, ___) => _placeholder(failed: failed),
      ),
    );
  }

  void _finishPreview() {
    final asset = widget.asset;
    // A zero-duration accessibility transition may end during Image.build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || widget.asset != asset || !_showPreview) return;
      setState(() => _showPreview = false);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    height: widget.height,
    child: LayoutBuilder(
      builder: (context, constraints) {
        _scheduleVisibilityCheck();
        if (!_requested) return _preview();
        return Image.asset(
          widget.asset,
          key: ValueKey(widget.asset),
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
          semanticLabel: widget.semanticLabel,
          frameBuilder: (context, image, frame, synchronous) {
            if (synchronous) return image;
            final loaded = frame != null;
            return Stack(
              fit: StackFit.expand,
              children: [
                // Keep the real preview underneath throughout the reveal. Removing
                // it on the first decoded frame would briefly reveal an empty slot.
                if (_showPreview)
                  ExcludeSemantics(excluding: loaded, child: _preview()),
                TweenAnimationBuilder<double>(
                  key: ValueKey('reveal:${widget.asset}'),
                  tween: Tween(begin: 0, end: loaded ? 1 : 0),
                  curve: Curves.easeOutCubic,
                  duration:
                      MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 520),
                  onEnd: loaded && _showPreview ? _finishPreview : null,
                  child: image,
                  builder:
                      (context, amount, child) => ClipRect(
                        clipper: _TopToBottomImageClipper(amount),
                        child: child,
                      ),
                ),
              ],
            );
          },
          errorBuilder: (context, error, stack) {
            if (assetPreviewBytes(widget.asset) != null) {
              return _preview(failed: true);
            }
            return widget.errorBuilder?.call(context, error, stack) ??
                _placeholder(failed: true);
          },
        );
      },
    ),
  );
}

class _TopToBottomImageClipper extends CustomClipper<Rect> {
  const _TopToBottomImageClipper(this.amount);

  final double amount;

  @override
  Rect getClip(Size size) =>
      Rect.fromLTWH(0, 0, size.width, size.height * amount.clamp(0.0, 1.0));

  @override
  bool shouldReclip(_TopToBottomImageClipper oldClipper) =>
      amount != oldClipper.amount;
}
