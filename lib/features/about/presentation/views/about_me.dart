import '../widgets/stats_row.dart';
import '../widgets/stats_grid.dart';
import '../widgets/section_label.dart';
import 'package:flutter/material.dart';
import '../widgets/bio_paragraph.dart';
import '../../data/models/stat_data.dart';
import '../widgets/mobile_platforms.dart';
import '../widgets/desktop_platform.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/animated_competency_tag.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key});

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _statsController;
  late AnimationController _pulseController;

  // Entry animations — 8 staggered blocks
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  // Stat counters
  final List<StatData> _stats = [
    StatData(value: 1, suffix: ' +', label: 'Years\nExperience'),
    StatData(value: 1, suffix: ' +', label: 'Number of apps'),
    StatData(value: 5, suffix: '', label: 'Platforms\nSupported'),
    StatData(value: 1, suffix: '', label: 'Number of companies worked'),
  ];
  late List<int> _animatedValues;

  @override
  void initState() {
    super.initState();

    _animatedValues = List.filled(_stats.length, 0);

    // ── Entry controller (all staggered reveals) ──────────────────
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    final intervals = [
      const Interval(0.00, 0.28, curve: Curves.easeOutCubic), // header
      const Interval(0.10, 0.38, curve: Curves.easeOutCubic), // divider line
      const Interval(0.18, 0.46, curve: Curves.easeOutCubic), // para 1
      const Interval(0.26, 0.54, curve: Curves.easeOutCubic), // para 2
      const Interval(0.34, 0.62, curve: Curves.easeOutCubic), // para 3
      const Interval(0.44, 0.70, curve: Curves.easeOutCubic), // stats row
      const Interval(0.54, 0.80, curve: Curves.easeOutCubic), // platforms
      const Interval(0.64, 0.90, curve: Curves.easeOutCubic), // competencies
    ];

    _fades = intervals
        .map((iv) => Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _entryController, curve: iv)))
        .toList();

    _slides = intervals
        .map((iv) => Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryController, curve: iv)))
        .toList();

    // ── Stats counter controller ───────────────────────────────────
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _statsController.addListener(_tickStats);

    // ── Pulse controller (ambient badge glow) ─────────────────────
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Start entry then trigger stats
    _entryController.forward().then((_) {
      _statsController.forward();
    });
  }

  void _tickStats() {
    final t = _statsController.value;
    setState(() {
      for (int i = 0; i < _stats.length; i++) {
        _animatedValues[i] = (_stats[i].value * t).round();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
    _statsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) => FadeTransition(
    opacity: _fades[index],
    child: SlideTransition(position: _slides[index], child: child),
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: DColors.primaryDark.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.horizontalPadding,
          vertical: context.verticalPadding * 1.4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── 0  Header ─────────────────────────────────────────
            _animated(0, NumberWithTitle(number: "01", title: "About Me")),

            SizedBox(height: context.sectionSpacing * 0.6),


            // ── 2-4  Bio paragraphs ────────────────────────────────
            _animated(
              2,
              BioParagraph(
                text:
                'I am a passionate Flutter Software Developer with a strong foundation in building cross-platform applications. My focus is on creating clean, scalable, and user-centric solutions that deliver exceptional experiences across all platforms.',
                context: context,
              ),
            ),
            SizedBox(height: context.elementSpacing),
            _animated(
              3,
              BioParagraph(
                text:
                'I care a lot about how code is structured, not just whether it works. Good architecture, reusable components, and readable code aren\'t just nice-to-haves — they\'re how I respect the next developer who touches the project (sometimes that\'s future me).',
                context: context,
              ),
            ),
            SizedBox(height: context.elementSpacing),
            _animated(
              4,
              BioParagraph(
                text:
                'I am constantly learning and exploring new technologies to stay at the forefront of cross-platform development, while delivering polished products that users love.',
                context: context,
              ),
            ),

            SizedBox(height: context.sectionSpacing * 1.3),

            // ── 5  Stats row ───────────────────────────────────────
            _animated(
              5,
              isMobile
                  ? StatsGrid(stats: _stats, animated: _animatedValues)
                  : StatsRow(stats: _stats, animated: _animatedValues),
            ),

            SizedBox(height: context.sectionSpacing * 1.4),

            // ── 6  Platforms ───────────────────────────────────────
            _animated(
              6,
              Column(
                children: [
                  SectionLabel(label: 'PLATFORMS I BUILD FOR', context: context),
                  SizedBox(height: context.sectionSpacing * 0.7),
                  isMobile
                      ? MobilePlatforms(context: context)
                      : DesktopPlatforms(context: context),
                ],
              ),
            ),

            SizedBox(height: context.sectionSpacing * 1.4),

            // ── 7  Competencies ────────────────────────────────────
            _animated(
              7,
              Column(
                children: [
                  SectionLabel(label: 'CORE COMPETENCIES', context: context),
                  SizedBox(height: context.sectionSpacing * 0.7),
                  Wrap(
                    spacing: isMobile ? 10.0 : 12.0,
                    runSpacing: isMobile ? 10.0 : 12.0,
                    alignment: WrapAlignment.center,
                    children: const [
                      'Flutter', 'Dart', 'State Management', 'REST APIs',
                      'Firebase', 'SQL/NoSQL', 'Git/GitHub', 'Clean Architecture',
                    ]
                        .asMap()
                        .entries
                        .map((e) => AnimatedCompetencyTag(
                      label: e.value,
                      index: e.key,
                      fontSize: context.competencyFontSize,
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




