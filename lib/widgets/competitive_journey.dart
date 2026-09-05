part of '../portfolio_app.dart';

/// CV milestones with verified profile corrections, not live API counters.
const _competitiveProfiles = [
  (
    name: 'Codeforces',
    value: '1200+',
    metric: 'Contest rating',
    asset: 'assets/icons/codeforces.png',
    color: Color(0xFF3158C9),
    url: 'https://codeforces.com/profile/Ibrahimovic_The_Lion',
  ),
  (
    name: 'LeetCode',
    value: '3',
    metric: 'Badges earned',
    asset: 'assets/icons/leetcode.png',
    color: Color(0xFF9A5B00),
    url: 'https://leetcode.com/u/sidratul15-11879/',
  ),
  (
    name: 'InterviewBit',
    value: '187',
    metric: 'Problems solved',
    asset: 'assets/icons/interviewbit.png',
    color: Color(0xFF087F6B),
    url:
        'https://www.interviewbit.com/profile/md-sidratul-montaha-183-15-11879/',
  ),
  (
    name: 'beecrowd',
    value: '230+',
    metric: 'Problems solved',
    asset: 'assets/icons/beecrowd.png',
    color: Color(0xFF7340A8),
    url: 'https://judge.beecrowd.com/en/profile/294737',
  ),
];

class _CompetitiveJourneySection extends StatelessWidget {
  const _CompetitiveJourneySection();

  @override
  Widget build(BuildContext context) => _SectionShell(
    color: _ink,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          number: '03',
          eyebrow: 'COMPETITIVE PROGRAMMING & PROBLEM SOLVING',
          title: 'The practice behind\nthe products.',
          description:
              'My engineering journey is grounded in competitive programming and hands-on problem solving across four platforms.',
        ),
        const SizedBox(height: 36),
        const _ProgrammingChampionship(),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns =
                constraints.maxWidth >= 1000
                    ? 4
                    : constraints.maxWidth >= 560
                    ? 2
                    : 1;
            final width = (constraints.maxWidth - 18 * (columns - 1)) / columns;
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                for (final profile in _competitiveProfiles)
                  SizedBox(
                    width: width,
                    child: _HoverLift(
                      distance: 4,
                      child: _CompetitiveProfileCard(
                        name: profile.name,
                        value: profile.value,
                        metric: profile.metric,
                        asset: profile.asset,
                        color: profile.color,
                        onTap: () => _launch(profile.url),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Visit each profile for the latest activity and achievements.',
          style: TextStyle(color: _muted, fontSize: 14, height: 1.5),
        ),
      ],
    ),
  );
}

class _ProgrammingChampionship extends StatelessWidget {
  const _ProgrammingChampionship();

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFAEC),
      border: Border.all(color: const Color(0xFFE5CD8D)),
      borderRadius: BorderRadius.circular(24),
      boxShadow: _softShadow,
    ),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final trophy = Container(
          padding: const EdgeInsets.all(17),
          decoration: const BoxDecoration(
            color: Color(0xFFFFEAB0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFF8A5A08),
            size: 34,
          ),
        );
        const copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHAMPION · 2019',
              style: TextStyle(
                color: Color(0xFF805106),
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 7),
            Text(
              'Take Off Programming Contest',
              style: TextStyle(
                color: _text,
                fontSize: 24,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        );
        return constraints.maxWidth < 520
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [trophy, const SizedBox(height: 20), copy],
            )
            : Row(
              children: [
                trophy,
                const SizedBox(width: 24),
                const Expanded(child: copy),
              ],
            );
      },
    ),
  );
}

class _CompetitiveProfileCard extends StatelessWidget {
  const _CompetitiveProfileCard({
    required this.name,
    required this.value,
    required this.metric,
    required this.asset,
    required this.color,
    required this.onTap,
  });

  final String name;
  final String value;
  final String metric;
  final String asset;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => _InteractiveCard(
    semanticLabel: '$name. $value $metric. View profile, opens in a new tab.',
    onTap: onTap,
    borderRadius: BorderRadius.circular(22),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProgressiveAssetImage(
                asset,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 46,
              height: 1.1,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(metric, style: const TextStyle(color: _muted, fontSize: 16)),
          const SizedBox(height: 26),
          const Divider(color: _line, height: 1),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  'View profile',
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(Icons.north_east_rounded, color: color, size: 19),
            ],
          ),
        ],
      ),
    ),
  );
}
