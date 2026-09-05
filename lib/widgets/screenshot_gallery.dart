import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A paged strip keeps all eight images reachable with touch, mouse or keyboard.
class ScreenshotGallery extends StatefulWidget {
  const ScreenshotGallery({super.key, required this.screenshots});
  final List<(String, String)> screenshots;

  @override
  State<ScreenshotGallery> createState() => _ScreenshotGalleryState();
}

class _ScreenshotGalleryState extends State<ScreenshotGallery> {
  final _controller = PageController();
  int _page = 0;
  int _perPage = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int page, int count) {
    if (page < 0 || page >= count) return;
    _controller.animateToPage(
      page,
      duration:
          MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final perPage =
            constraints.maxWidth >= 850
                ? 4
                : constraints.maxWidth >= 600
                ? 3
                : constraints.maxWidth >= 420
                ? 2
                : 1;
        final pages = (widget.screenshots.length / perPage).ceil();
        if (_perPage != perPage) {
          _perPage = perPage;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _controller.hasClients) {
              _controller.jumpToPage(0);
              setState(() => _page = 0);
            }
          });
        }
        final current = _page.clamp(0, pages - 1);
        final start = current * perPage + 1;
        final end = ((current + 1) * perPage).clamp(
          1,
          widget.screenshots.length,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: const Text(
                'Official product screens',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Swipe or use the arrows. Select a screen to enlarge it.',
              style: TextStyle(color: Color(0xFF5E6B7D), height: 1.5),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: constraints.maxWidth < 600 ? 425 : 485,
              child: ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: PageView.builder(
                  key: const ValueKey('product-screenshot-pages'),
                  controller: _controller,
                  itemCount: pages,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder:
                      (context, page) => Row(
                        children: List.generate(perPage, (slot) {
                          final index = page * perPage + slot;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 5,
                              ),
                              child:
                                  index >= widget.screenshots.length
                                      ? const SizedBox.shrink()
                                      : _ScreenshotTile(
                                        item: widget.screenshots[index],
                                        index: index,
                                        onTap:
                                            () => showDialog<void>(
                                              context: context,
                                              builder:
                                                  (_) => _ScreenshotViewer(
                                                    screenshots:
                                                        widget.screenshots,
                                                    initialIndex: index,
                                                  ),
                                            ),
                                      ),
                            ),
                          );
                        }),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  tooltip: 'Previous screenshots',
                  onPressed:
                      current == 0 ? null : () => _go(current - 1, pages),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      '$start–$end of ${widget.screenshots.length}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'Next screenshots',
                  onPressed:
                      current == pages - 1
                          ? null
                          : () => _go(current + 1, pages),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(
                  pages,
                  (page) => Semantics(
                    selected: current == page,
                    child: IconButton(
                      tooltip: 'Screenshot page ${page + 1} of $pages',
                      onPressed: () => _go(page, pages),
                      icon: Icon(
                        current == page ? Icons.circle : Icons.circle_outlined,
                        size: current == page ? 12 : 9,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ScreenshotTile extends StatelessWidget {
  const _ScreenshotTile({
    required this.item,
    required this.index,
    required this.onTap,
  });
  final (String, String) item;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onTap,
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(10),
      backgroundColor: const Color(0xFF111827),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    child: Semantics(
      label: 'Enlarge Grozziie ${item.$1} screenshot ${index + 1}',
      excludeSemantics: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(item.$1, style: const TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.zoom_in_rounded, size: 17),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                item.$2,
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) =>
                        const Center(child: Text('Preview unavailable')),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ScreenshotViewer extends StatefulWidget {
  const _ScreenshotViewer({
    required this.screenshots,
    required this.initialIndex,
  });
  final List<(String, String)> screenshots;
  final int initialIndex;
  @override
  State<_ScreenshotViewer> createState() => _ScreenshotViewerState();
}

class _ScreenshotViewerState extends State<_ScreenshotViewer> {
  late int _index = widget.initialIndex;

  void _move(int delta) {
    final next = _index + delta;
    if (next >= 0 && next < widget.screenshots.length) {
      setState(() => _index = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.screenshots[_index];
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.escape):
            () => Navigator.pop(context),
      },
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850, maxHeight: 900),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        header: true,
                        liveRegion: true,
                        child: Text(
                          'Grozziie · ${item.$1} · ${_index + 1}/${widget.screenshots.length}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    IconButton(
                      autofocus: true,
                      tooltip: 'Close screenshot viewer',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Expanded(
                  child: InteractiveViewer(
                    key: ValueKey(_index),
                    minScale: 1,
                    maxScale: 4,
                    child: Image.asset(
                      item.$2,
                      fit: BoxFit.contain,
                      semanticLabel:
                          'Grozziie ${item.$1} screenshot ${_index + 1}',
                      errorBuilder:
                          (_, __, ___) =>
                              const Center(child: Text('Preview unavailable')),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pinch or scroll to zoom · ← → to browse · Esc to close',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Previous image',
                      onPressed: _index == 0 ? null : () => _move(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text('${_index + 1} / ${widget.screenshots.length}'),
                    IconButton(
                      tooltip: 'Next image',
                      onPressed:
                          _index == widget.screenshots.length - 1
                              ? null
                              : () => _move(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
