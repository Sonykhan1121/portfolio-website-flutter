part of '../portfolio_app.dart';

/// Past educational work, deliberately kept within About rather than navigation.
class _TeachingCommunityCard extends StatelessWidget {
  const _TeachingCommunityCard({super.key});

  static const _channelUrl = 'https://www.youtube.com/@sidratul15';
  static const _thumbnail = 'assets/images/bengali-computer-lessons.jpg';
  static const _description =
      'Created 18 beginner-friendly video lessons helping children and newcomers learn everyday computer skills in Bengali.';

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22);
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: _cardShadow),
      child: Material(
        color: _panel,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: _line),
        ),
        clipBehavior: Clip.antiAlias,
        child: _InteractiveCard(
          isLink: true,
          semanticLabel:
              'Sharing knowledge in Bengali. $_description Explore the lessons on YouTube. Opens in a new tab.',
          onTap: () => _launch(_channelUrl),
          borderRadius: radius,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontal =
                    constraints.maxWidth >= 740 &&
                    MediaQuery.textScalerOf(context).scale(16) <= 20;
                final thumbnail = ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ProgressiveAssetImage(
                          _thumbnail,
                          fit: BoxFit.cover,
                          semanticLabel:
                              'Bengali computer lesson video thumbnail',
                          loadingPlaceholder: ColoredBox(color: _softFill),
                        ),
                        Center(
                          child: Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE11D48),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 14,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 34,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                const details = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.youtube,
                          color: Color(0xFFE11D48),
                          size: 19,
                        ),
                        SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            'TEACHING & COMMUNITY',
                            style: TextStyle(
                              color: _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sharing knowledge in Bengali',
                      style: TextStyle(
                        color: _text,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _description,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: 18),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Explore the lessons',
                            style: TextStyle(
                              color: _sky,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.open_in_new_rounded, color: _sky, size: 18),
                      ],
                    ),
                  ],
                );
                return horizontal
                    ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 290, child: thumbnail),
                        const SizedBox(width: 28),
                        const Expanded(child: details),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        thumbnail,
                        const SizedBox(height: 22),
                        details,
                      ],
                    );
              },
            ),
          ),
        ),
      ),
    );
  }
}
