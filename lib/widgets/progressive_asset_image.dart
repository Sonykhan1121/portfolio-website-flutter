import 'package:flutter/material.dart';

/// Reserves the existing image slot, then requests the asset near the viewport.
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
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double preloadMargin;

  @override
  State<ProgressiveAssetImage> createState() => _ProgressiveAssetImageState();
}

class _ProgressiveAssetImageState extends State<ProgressiveAssetImage>
    with WidgetsBindingObserver {
  final _positions = <ScrollPosition>{};
  bool _requested = false;
  bool _checkScheduled = false;

  @override
  void initState() {
    super.initState();
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
    if (oldWidget.asset != widget.asset) {
      _requested = false;
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

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    height: widget.height,
    child: LayoutBuilder(
      builder: (context, constraints) {
        _scheduleVisibilityCheck();
        if (!_requested) return _placeholder();
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
                if (!loaded) _placeholder(),
                AnimatedOpacity(
                  opacity: loaded ? 1 : 0,
                  duration:
                      MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : const Duration(milliseconds: 180),
                  child: image,
                ),
              ],
            );
          },
          errorBuilder:
              widget.errorBuilder ?? (_, __, ___) => _placeholder(failed: true),
        );
      },
    ),
  );
}
