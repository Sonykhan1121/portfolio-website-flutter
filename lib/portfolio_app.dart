import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/portfolio_data.dart';
import 'models/repository_item.dart';

const _ink = Color(0xFFFFFFFF);
const _inkSoft = Color(0xFFF6F8FB);
const _panel = Color(0xFFFFFFFF);
const _mint = Color(0xFF087F6B);
const _sky = Color(0xFF3158C9);
const _text = Color(0xFF111827);
const _muted = Color(0xFF5E6B7D);
const _line = Color(0xFFDCE3EC);
const _onAccent = Color(0xFFFFFFFF);
const _softFill = Color(0xFFF2F5F9);
const _deviceFrame = Color(0xFF111827);
const _deviceMuted = Color(0xFFB7C2D0);
const _contentWidth = 1180.0;

const _cardShadow = <BoxShadow>[
  BoxShadow(
    color: Color(0x1A0F172A),
    blurRadius: 30,
    spreadRadius: -5,
    offset: Offset(0, 14),
  ),
  BoxShadow(
    color: Color(0x100F172A),
    blurRadius: 8,
    spreadRadius: -2,
    offset: Offset(0, 3),
  ),
];

const _softShadow = <BoxShadow>[
  BoxShadow(
    color: Color(0x160F172A),
    blurRadius: 18,
    spreadRadius: -4,
    offset: Offset(0, 8),
  ),
  BoxShadow(
    color: Color(0x0C0F172A),
    blurRadius: 5,
    spreadRadius: -1,
    offset: Offset(0, 2),
  ),
];

const _githubUrl = 'https://github.com/Sonykhan1121';
const _linkedinUrl = 'https://www.linkedin.com/in/sidratul-montaha-441b80175/';
const _cvUrl =
    'https://drive.google.com/file/d/1XjZ2kmgI1k1DLG87sAyArOjTcd1m9OW5/view?usp=sharing';
const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.grozziie.printer';
const _appStoreUrl = 'https://apps.apple.com/us/app/grozziie/id6476171035';
const _email = 'sonykhan1121@gmail.com';

Future<void> _launch(String value) async {
  final uri = Uri.parse(value);
  await launchUrl(uri, webOnlyWindowName: '_blank');
}

Future<void> _emailMe() async {
  final uri = Uri(
    scheme: 'mailto',
    path: _email,
    queryParameters: {
      'subject': 'Project enquiry for Sidratul Montaha',
      'body': 'Hi Sidratul,\n\nI would like to discuss...',
    },
  );
  await launchUrl(uri);
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _mint,
      brightness: Brightness.light,
      surface: _ink,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidratul Montaha — Flutter Software Engineer',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: scheme,
        scaffoldBackgroundColor: _ink,
        useMaterial3: true,
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _text,
          displayColor: _text,
          fontFamily: 'Arial',
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0x6655D6BE),
        ),
      ),
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _heroKey = GlobalKey();
  final _workKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();

  String _filter = 'All';
  String _query = '';
  bool _showAllRepositories = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final target = key.currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeOutCubic,
      alignment: 0.02,
    );
  }

  void _openMobileMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: _panel,
      showDragHandle: true,
      builder:
          (sheetContext) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MobileNavItem(
                    label: 'Home',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_heroKey);
                    },
                  ),
                  _MobileNavItem(
                    label: 'Grozziie',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_workKey);
                    },
                  ),
                  _MobileNavItem(
                    label: 'Projects',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_projectsKey);
                    },
                  ),
                  _MobileNavItem(
                    label: 'About',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_aboutKey);
                    },
                  ),
                  _MobileNavItem(
                    label: 'Contact',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_contactKey);
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  List<RepositoryItem> get _filteredRepositories {
    final normalized = _query.trim().toLowerCase();
    return repositories.where((repo) {
      final matchesFilter = _filter == 'All' || repo.language == _filter;
      final haystack =
          '${repo.name} ${repo.description} ${repo.language} ${repo.category}'
              .toLowerCase();
      return matchesFilter &&
          (normalized.isEmpty || haystack.contains(normalized));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 76),
                  Container(
                    key: _heroKey,
                    child: _HeroSection(onExplore: () => _scrollTo(_workKey)),
                  ),
                  Container(key: _workKey, child: const _GrozziieSection()),
                  _FeaturedProjectsSection(key: _projectsKey),
                  _RepositorySection(
                    searchController: _searchController,
                    selectedFilter: _filter,
                    repositories: _filteredRepositories,
                    showAll: _showAllRepositories,
                    onSearch: (value) {
                      setState(() {
                        _query = value;
                        _showAllRepositories = false;
                      });
                    },
                    onFilter: (value) {
                      setState(() {
                        _filter = value;
                        _showAllRepositories = false;
                      });
                    },
                    onToggleAll:
                        () => setState(
                          () => _showAllRepositories = !_showAllRepositories,
                        ),
                  ),
                  Container(key: _aboutKey, child: const _AboutSection()),
                  Container(key: _contactKey, child: const _ContactSection()),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _NavigationBar(
                onHome: () => _scrollTo(_heroKey),
                onWork: () => _scrollTo(_workKey),
                onProjects: () => _scrollTo(_projectsKey),
                onAbout: () => _scrollTo(_aboutKey),
                onContact: () => _scrollTo(_contactKey),
                onMenu: _openMobileMenu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.onHome,
    required this.onWork,
    required this.onProjects,
    required this.onAbout,
    required this.onContact,
    required this.onMenu,
  });

  final VoidCallback onHome;
  final VoidCallback onWork;
  final VoidCallback onProjects;
  final VoidCallback onAbout;
  final VoidCallback onContact;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: _ink.withValues(alpha: 0.97),
        border: const Border(bottom: BorderSide(color: _line)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 760;
                return Row(
                  children: [
                    InkWell(
                      onTap: onHome,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [_mint, _sky],
                                ),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: const Text(
                                'SM',
                                style: TextStyle(
                                  color: _onAccent,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (!compact)
                              const Text(
                                'SIDRATUL MONTAHA',
                                style: TextStyle(
                                  color: _text,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                  letterSpacing: 1.2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (!compact) ...[
                      _NavLink(label: 'Grozziie', onTap: onWork),
                      _NavLink(label: 'Projects', onTap: onProjects),
                      _NavLink(label: 'About', onTap: onAbout),
                      const SizedBox(width: 10),
                      _SmallCta(label: 'Let’s talk', onTap: onContact),
                    ] else
                      IconButton(
                        tooltip: 'Open navigation',
                        onPressed: onMenu,
                        icon: const Icon(Icons.menu_rounded, color: _text),
                      ),
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

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  const _MobileNavItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
      trailing: const Icon(Icons.arrow_forward_rounded, color: _mint),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: const LinearGradient(
        colors: [_ink, Color(0xFFF0FAF7), Color(0xFFF5F7FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      topPadding: 78,
      bottomPadding: 96,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final copy = _HeroCopy(onExplore: onExplore);
          final visual = _ProfileVisual(compact: !wide);

          return Column(
            children: [
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 12, child: copy),
                    const SizedBox(width: 58),
                    Expanded(flex: 8, child: visual),
                  ],
                )
              else ...[
                copy,
                const SizedBox(height: 54),
                visual,
              ],
              const SizedBox(height: 54),
              const _MetricStrip(),
            ],
          );
        },
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow(label: 'FLUTTER SOFTWARE ENGINEER'),
        const SizedBox(height: 22),
        Text(
          'I ship mobile products\nthat work in the real world.',
          style: TextStyle(
            color: _text,
            height: 1.03,
            letterSpacing: -2.1,
            fontWeight: FontWeight.w900,
            fontSize: math.min(
              68,
              math.max(43, MediaQuery.sizeOf(context).width * 0.054),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: const Text(
            'I’m Sidratul Montaha, a Flutter developer building reliable Android and iOS experiences across Bluetooth, IoT, real-time services, and polished product interfaces.',
            style: TextStyle(
              color: _muted,
              height: 1.65,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _PrimaryButton(
              label: 'Explore my work',
              icon: Icons.arrow_downward_rounded,
              onTap: onExplore,
            ),
            _OutlineButton(
              label: 'Download CV',
              icon: Icons.download_rounded,
              onTap: () => _launch(_cvUrl),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _SocialPill(
              label: 'GitHub',
              icon: FontAwesomeIcons.github,
              onTap: () => _launch(_githubUrl),
            ),
            _SocialPill(
              label: 'LinkedIn',
              icon: FontAwesomeIcons.linkedinIn,
              onTap: () => _launch(_linkedinUrl),
            ),
            _SocialPill(
              label: 'Email',
              icon: FontAwesomeIcons.envelope,
              onTap: _emailMe,
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileVisual extends StatefulWidget {
  const _ProfileVisual({required this.compact});

  final bool compact;

  @override
  State<_ProfileVisual> createState() => _ProfileVisualState();
}

class _ProfileVisualState extends State<_ProfileVisual>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.compact ? 430.0 : 515.0;
    return SizedBox(
      height: height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                left: 30,
                right: 12,
                top: 24 + (_controller.value * 8),
                bottom: 6,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _mint.withValues(alpha: 0.32),
                        _sky.withValues(alpha: 0.12),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(42),
                  ),
                ),
              ),
              Positioned.fill(
                right: 30,
                bottom: 28,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(38),
                    border: Border.all(color: _line, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: _mint.withValues(alpha: 0.14),
                        blurRadius: 60,
                        offset: const Offset(0, 28),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Image.asset(
                      'assets/images/hero_portrait_2026.png',
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 0,
                child: _FloatingBadge(
                  icon: Icons.verified_rounded,
                  title: 'Production Flutter',
                  subtitle: 'Android + iOS',
                  color: _sky,
                ),
              ),
              Positioned(
                bottom: 4,
                left: 0,
                child: _FloatingBadge(
                  icon: Icons.bluetooth_rounded,
                  title: 'Device experiences',
                  subtitle: 'Bluetooth • IoT',
                  color: _mint,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: _panel.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: 0.42)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip();

  @override
  Widget build(BuildContext context) {
    const metrics = [
      ('50K+', 'Grozziie Android downloads'),
      ('32', 'Public GitHub repositories'),
      ('2', 'Live mobile platforms'),
      ('2024', 'Production engineering since'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        final width =
            compact
                ? (constraints.maxWidth - 12) / 2
                : (constraints.maxWidth - 36) / 4;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              metrics
                  .map(
                    (metric) => Container(
                      width: width,
                      constraints: const BoxConstraints(minHeight: 102),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _inkSoft,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: _line),
                        boxShadow: _softShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            metric.$1,
                            style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w900,
                              color: _mint,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            metric.$2,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 12,
                              height: 1.35,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _GrozziieSection extends StatelessWidget {
  const _GrozziieSection();

  static const screenshots = [
    ('Google Play', 'assets/images/projects/grozziie/play_01.webp'),
    ('App Store', 'assets/images/projects/grozziie/ios_01.jpg'),
    ('Google Play', 'assets/images/projects/grozziie/play_02.webp'),
    ('App Store', 'assets/images/projects/grozziie/ios_02.jpg'),
    ('Google Play', 'assets/images/projects/grozziie/play_03.webp'),
    ('App Store', 'assets/images/projects/grozziie/ios_03.jpg'),
    ('Google Play', 'assets/images/projects/grozziie/play_04.webp'),
    ('App Store', 'assets/images/projects/grozziie/ios_04.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      color: _inkSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '01',
            eyebrow: 'FEATURED RELEASE',
            title: 'Grozziie — built for the\nway people actually print.',
            description:
                'A production Flutter application serving real customers on Android and iOS, with connected-printer workflows at its core.',
          ),
          const SizedBox(height: 42),
          _HoverLift(
            child: Container(
              padding: EdgeInsets.all(
                MediaQuery.sizeOf(context).width < 650 ? 22 : 38,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF0FAF7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFB9DED5)),
                boxShadow: [
                  ..._cardShadow,
                  BoxShadow(
                    color: _mint.withValues(alpha: 0.10),
                    blurRadius: 48,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 820;
                      final identity = const _GrozziieIdentity();
                      final metrics = const _GrozziieMetrics();
                      return wide
                          ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 11, child: identity),
                              const SizedBox(width: 44),
                              Expanded(flex: 9, child: metrics),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              identity,
                              const SizedBox(height: 34),
                              metrics,
                            ],
                          );
                    },
                  ),
                  const SizedBox(height: 36),
                  const Divider(color: _line),
                  const SizedBox(height: 34),
                  const Text(
                    'WHAT THE PRODUCT DELIVERS',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _FeatureGrid(),
                  const SizedBox(height: 42),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Official product screens',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _softFill,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: _line),
                        ),
                        child: const Text(
                          'Scroll to explore →',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).width < 650 ? 410 : 505,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: screenshots.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 18),
                      itemBuilder: (context, index) {
                        final item = screenshots[index];
                        return _StoreScreenshot(label: item.$1, asset: item.$2);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrozziieIdentity extends StatelessWidget {
  const _GrozziieIdentity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/projects/grozziie/icon.webp',
                width: 74,
                height: 74,
              ),
            ),
            const SizedBox(width: 18),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grozziie',
                    style: TextStyle(
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'PRODUCTION MOBILE APPLICATION',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        const Text(
          'Printing, labels, and connected-device workflows—designed as one clear cross-platform experience.',
          style: TextStyle(
            color: _text,
            fontSize: 24,
            height: 1.35,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'My work focuses on developing and maintaining Flutter features for the live Android and iOS product, including Bluetooth and device-connected experiences, reusable UI, and reliable service integration.',
          style: TextStyle(color: _muted, fontSize: 15.5, height: 1.68),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _StoreButton(
              label: 'Google Play',
              icon: FontAwesomeIcons.googlePlay,
              onTap: () => _launch(_playStoreUrl),
            ),
            _StoreButton(
              label: 'App Store',
              icon: FontAwesomeIcons.apple,
              onTap: () => _launch(_appStoreUrl),
            ),
          ],
        ),
      ],
    );
  }
}

class _GrozziieMetrics extends StatelessWidget {
  const _GrozziieMetrics();

  @override
  Widget build(BuildContext context) {
    const metrics = [
      ('50K+', 'Android downloads'),
      ('Android + iOS', 'Published platforms'),
      ('Live', 'Production status'),
    ];
    return Column(
      children: [
        ...metrics.map(
          (metric) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: _inkSoft,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: _line),
              boxShadow: _softShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: _mint,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: _mint, blurRadius: 10)],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    metric.$2,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  metric.$1,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _mint.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: _mint.withValues(alpha: 0.3)),
            boxShadow: _softShadow,
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.engineering_rounded, color: _mint, size: 22),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY ROLE',
                      style: TextStyle(
                        color: _mint,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Flutter Software Developer',
                      style: TextStyle(
                        color: _text,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.bluetooth_rounded,
        'Bluetooth setup',
        'Connect and configure supported printers.',
      ),
      (
        Icons.print_rounded,
        'Multi-format printing',
        'Print PDFs, Word files, images, and labels.',
      ),
      (
        Icons.design_services_rounded,
        'Label creation',
        'Build labels with practical tools and templates.',
      ),
      (
        Icons.tune_rounded,
        'Output controls',
        'Choose paper, orientation, and quality settings.',
      ),
      (
        Icons.preview_rounded,
        'Print preview',
        'Review output before sending a job to the device.',
      ),
      (
        Icons.history_rounded,
        'Print management',
        'Access previous work through organized history.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 980
                ? 3
                : constraints.maxWidth >= 600
                ? 2
                : 1;
        const gap = 12.0;
        final itemWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              items
                  .map(
                    (item) => Container(
                      width: itemWidth,
                      constraints: const BoxConstraints(minHeight: 126),
                      padding: const EdgeInsets.all(17),
                      decoration: BoxDecoration(
                        color: _inkSoft,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _line),
                        boxShadow: _softShadow,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _mint.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.$1, color: _mint, size: 20),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.$2,
                                  style: const TextStyle(
                                    color: _text,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.$3,
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 12.5,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _StoreScreenshot extends StatelessWidget {
  const _StoreScreenshot({required this.label, required this.asset});

  final String label;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 650;
    return Container(
      width: compact ? 190 : 232,
      padding: const EdgeInsets.fromLTRB(9, 11, 9, 9),
      decoration: BoxDecoration(
        color: _deviceFrame,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFF2D394A)),
        boxShadow: _cardShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  label == 'App Store'
                      ? FontAwesomeIcons.apple
                      : FontAwesomeIcons.googlePlay,
                  color: _deviceMuted,
                  size: 11,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: const TextStyle(
                    color: _deviceMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Image.asset(
                asset,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedProjectsSection extends StatelessWidget {
  const _FeaturedProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      color: _ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '02',
            eyebrow: 'SELECTED ENGINEERING WORK',
            title: 'Products, packages,\nand practical experiments.',
            description:
                'A curated set of mobile, desktop, package, and machine-learning work from my public repositories.',
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns =
                  constraints.maxWidth >= 980
                      ? 3
                      : constraints.maxWidth >= 630
                      ? 2
                      : 1;
              const gap = 18.0;
              final itemWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    featuredProjects
                        .map(
                          (project) => SizedBox(
                            width: itemWidth,
                            height: 350,
                            child: _FeaturedProjectCard(project: project),
                          ),
                        )
                        .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  const _FeaturedProjectCard({required this.project});

  final FeaturedProject project;

  @override
  Widget build(BuildContext context) {
    final colorA = Color(project.colors.first);
    final colorB = Color(project.colors.last);
    return _HoverLift(
      child: InkWell(
        onTap: () => _launch(project.url),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          constraints: const BoxConstraints(minHeight: 330),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.lerp(_panel, colorB, 0.13)!, _panel],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colorA.withValues(alpha: 0.23)),
            boxShadow: _cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colorA, colorB]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(project.icon, color: Colors.white, size: 25),
                  ),
                  const Spacer(),
                  Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _softFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _line),
                    ),
                    child: const Icon(
                      Icons.north_east_rounded,
                      color: _text,
                      size: 19,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                project.kicker,
                style: TextStyle(
                  color: colorA,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                project.title,
                style: const TextStyle(
                  color: _text,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  project.description,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children:
                    project.tags
                        .map((tag) => _Tag(label: tag, color: colorA))
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RepositorySection extends StatelessWidget {
  const _RepositorySection({
    required this.searchController,
    required this.selectedFilter,
    required this.repositories,
    required this.showAll,
    required this.onSearch,
    required this.onFilter,
    required this.onToggleAll,
  });

  final TextEditingController searchController;
  final String selectedFilter;
  final List<RepositoryItem> repositories;
  final bool showAll;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    const filters = [
      'All',
      'Dart',
      'Kotlin',
      'Java',
      'C++',
      'Python',
      'HTML',
      'Other',
    ];
    final visible = showAll ? repositories : repositories.take(12).toList();

    return _SectionShell(
      color: _inkSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '03',
            eyebrow: 'COMPLETE GITHUB ARCHIVE',
            title: 'Every public repository,\norganized in one place.',
            description:
                'Search and filter the complete public archive—from production-minded Flutter work to native Android, problem solving, and learning projects.',
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _line),
              boxShadow: _cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  onChanged: onSearch,
                  style: const TextStyle(color: _text, fontSize: 15),
                  decoration: InputDecoration(
                    hintText:
                        'Search repositories, technologies, or categories',
                    hintStyle: const TextStyle(color: _muted),
                    prefixIcon: const Icon(Icons.search_rounded, color: _mint),
                    filled: true,
                    fillColor: _inkSoft,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: _mint, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        filters
                            .map(
                              (filter) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: selectedFilter == filter,
                                  onSelected: (_) => onFilter(filter),
                                  backgroundColor: _ink,
                                  selectedColor: _mint,
                                  side: BorderSide(
                                    color:
                                        selectedFilter == filter
                                            ? _mint
                                            : _line,
                                  ),
                                  labelStyle: TextStyle(
                                    color:
                                        selectedFilter == filter
                                            ? _onAccent
                                            : _muted,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '${repositories.length} repositories found',
                style: const TextStyle(
                  color: _muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Text(
                'Updated from public GitHub data',
                style: TextStyle(color: _muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (visible.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: _panel,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _line),
                boxShadow: _cardShadow,
              ),
              child: const Column(
                children: [
                  Icon(Icons.search_off_rounded, color: _muted, size: 34),
                  SizedBox(height: 12),
                  Text(
                    'No repositories match this search.',
                    style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final columns =
                    constraints.maxWidth >= 1000
                        ? 3
                        : constraints.maxWidth >= 650
                        ? 2
                        : 1;
                const gap = 14.0;
                final itemWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children:
                      visible
                          .map(
                            (repo) => SizedBox(
                              width: itemWidth,
                              height: 232,
                              child: _RepositoryCard(repo: repo),
                            ),
                          )
                          .toList(),
                );
              },
            ),
          if (repositories.length > 12) ...[
            const SizedBox(height: 28),
            Center(
              child: _OutlineButton(
                label:
                    showAll
                        ? 'Show fewer repositories'
                        : 'Show all ${repositories.length} repositories',
                icon:
                    showAll
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                onTap: onToggleAll,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RepositoryCard extends StatelessWidget {
  const _RepositoryCard({required this.repo});

  final RepositoryItem repo;

  Color get _languageColor {
    return switch (repo.language) {
      'Dart' => const Color(0xFF54C5F8),
      'Kotlin' => const Color(0xFFA97BFF),
      'Java' => const Color(0xFFFFA05A),
      'C++' => const Color(0xFFFF6F91),
      'Python' => const Color(0xFFFFD166),
      'HTML' => const Color(0xFFFF7B54),
      'Liquid' => const Color(0xFF7DDA8A),
      _ => _muted,
    };
  }

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      distance: 4,
      child: InkWell(
        onTap: () => _launch(repo.url),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 218),
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: _panel,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _line),
            boxShadow: _cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 37,
                    height: 37,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _languageColor.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      Icons.folder_open_rounded,
                      color: _languageColor,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.north_east_rounded, color: _muted, size: 18),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                repo.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Text(
                  repo.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    height: 1.5,
                    fontSize: 12.8,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _languageColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    repo.language,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    repo.updated,
                    style: const TextStyle(color: _muted, fontSize: 10.5),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      color: _ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '04',
            eyebrow: 'ABOUT & CAPABILITIES',
            title: 'Engineering across the\nwhole product journey.',
            description:
                'From responsive interfaces to device communication and production delivery, I focus on maintainable systems that feel simple to use.',
          ),
          const SizedBox(height: 42),
          const _CapabilityGrid(),
          const SizedBox(height: 72),
          const _JourneySection(),
        ],
      ),
    );
  }
}

class _CapabilityGrid extends StatelessWidget {
  const _CapabilityGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.phone_android_rounded,
        'Mobile engineering',
        'Cross-platform Android and iOS development with Flutter and Dart.',
        ['Flutter', 'Dart', 'Android', 'iOS'],
      ),
      (
        Icons.bluetooth_connected_rounded,
        'Devices & intelligence',
        'Bluetooth, IoT, TensorFlow Lite, face workflows, and connected hardware.',
        ['Bluetooth', 'IoT', 'TFLite', 'Face recognition'],
      ),
      (
        Icons.account_tree_rounded,
        'Architecture & data',
        'Clean application boundaries, reusable components, state, APIs, and persistence.',
        ['MVVM', 'Provider', 'BLoC', 'REST', 'WebSockets'],
      ),
      (
        Icons.rocket_launch_rounded,
        'Production delivery',
        'Performance-minded implementation, Git workflows, testing, and repeatable releases.',
        ['GitFlow', 'CI/CD', 'Testing', 'Performance'],
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 800 ? 2 : 1;
        const gap = 16.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              items
                  .map(
                    (item) => Container(
                      width: width,
                      constraints: const BoxConstraints(minHeight: 232),
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
                          Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _mint.withValues(alpha: 0.11),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(item.$1, color: _mint, size: 24),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            item.$3,
                            style: const TextStyle(
                              color: _muted,
                              height: 1.55,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 17),
                          Wrap(
                            spacing: 7,
                            runSpacing: 7,
                            children:
                                item.$4
                                    .map(
                                      (tag) => _Tag(label: tag, color: _mint),
                                    )
                                    .toList(),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _JourneySection extends StatelessWidget {
  const _JourneySection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 860;
        const work = _JourneyCard(
          icon: Icons.work_outline_rounded,
          eyebrow: 'DEC 2024 — PRESENT',
          title: 'Software Engineer',
          subtitle: 'THT-Space Electrical Company Ltd. • Bangladesh',
          description:
              'Developing and maintaining production Flutter features across Android and iOS. My work spans Bluetooth and IoT, face-attendance workflows, REST APIs, WebSockets, Firebase, reusable UI, and CI/CD practices.',
        );
        const education = _JourneyCard(
          icon: Icons.school_outlined,
          eyebrow: '2018 — 2023',
          title: 'BSc in Computer Science & Engineering',
          subtitle: 'Daffodil International University • CGPA 3.82 / 4.00',
          description:
              'Built a strong computer-science foundation through software engineering and problem solving. Champion of the Take Off Programming Contest 2019.',
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional journey',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 22),
            if (wide)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: work),
                  SizedBox(width: 16),
                  Expanded(child: education),
                ],
              )
            else
              const Column(children: [work, SizedBox(height: 16), education]),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _sky.withValues(alpha: 0.1),
                    _mint.withValues(alpha: 0.07),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _line),
                boxShadow: _softShadow,
              ),
              child: const Wrap(
                alignment: WrapAlignment.spaceAround,
                runAlignment: WrapAlignment.center,
                spacing: 34,
                runSpacing: 20,
                children: [
                  _MiniStat(value: '1200+', label: 'Codeforces rating'),
                  _MiniStat(value: '3', label: 'LeetCode badges'),
                  _MiniStat(value: '220+', label: 'InterviewBit problems'),
                  _MiniStat(value: '230+', label: 'beecrowd problems'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _JourneyCard extends StatelessWidget {
  const _JourneyCard({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 304),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _sky.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: _sky, size: 22),
          ),
          const SizedBox(height: 18),
          Text(
            eyebrow,
            style: const TextStyle(
              color: _mint,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.35,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: _sky,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            description,
            style: const TextStyle(color: _muted, height: 1.58, fontSize: 13.5),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _text,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _inkSoft,
      child: Column(
        children: [
          _SectionShell(
            bottomPadding: 64,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width < 650 ? 24 : 52,
                vertical: MediaQuery.sizeOf(context).width < 650 ? 42 : 62,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F8F4), Color(0xFFEEF3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFBDDCD5)),
                boxShadow: _cardShadow,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  final copy = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _Eyebrow(label: 'AVAILABLE FOR GOOD WORK'),
                      const SizedBox(height: 18),
                      Text(
                        'Let’s build something\npeople can rely on.',
                        style: TextStyle(
                          color: _text,
                          fontSize: wide ? 46 : 36,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'For Flutter products, connected-device experiences, or thoughtful mobile engineering, send me a note.',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
                  );
                  final actions = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _PrimaryButton(
                        label: 'Email me',
                        icon: Icons.send_rounded,
                        onTap: _emailMe,
                        expand: true,
                      ),
                      const SizedBox(height: 11),
                      _OutlineButton(
                        label: 'Connect on LinkedIn',
                        icon: FontAwesomeIcons.linkedinIn,
                        onTap: () => _launch(_linkedinUrl),
                        expand: true,
                      ),
                      const SizedBox(height: 18),
                      const SelectableText(
                        _email,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );

                  return wide
                      ? Row(
                        children: [
                          Expanded(flex: 12, child: copy),
                          const SizedBox(width: 56),
                          Expanded(flex: 6, child: actions),
                        ],
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [copy, const SizedBox(height: 34), actions],
                      );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: _ink,
              border: Border(top: BorderSide(color: _line)),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _contentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 30,
                  ),
                  child: Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        '© 2026 Sidratul Montaha. Built with Flutter.',
                        style: TextStyle(color: _muted, fontSize: 12.5),
                      ),
                      Wrap(
                        spacing: 6,
                        children: [
                          IconButton(
                            tooltip: 'GitHub',
                            onPressed: () => _launch(_githubUrl),
                            icon: const Icon(
                              FontAwesomeIcons.github,
                              color: _muted,
                              size: 17,
                            ),
                          ),
                          IconButton(
                            tooltip: 'LinkedIn',
                            onPressed: () => _launch(_linkedinUrl),
                            icon: const Icon(
                              FontAwesomeIcons.linkedinIn,
                              color: _muted,
                              size: 17,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Email',
                            onPressed: _emailMe,
                            icon: const Icon(
                              FontAwesomeIcons.envelope,
                              color: _muted,
                              size: 17,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.child,
    this.color,
    this.background,
    this.topPadding = 104,
    this.bottomPadding = 104,
  });

  final Widget child;
  final Color? color;
  final Gradient? background;
  final double topPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final horizontal = MediaQuery.sizeOf(context).width < 650 ? 18.0 : 28.0;
    final verticalScale = MediaQuery.sizeOf(context).width < 650 ? 0.72 : 1.0;
    return Container(
      width: double.infinity,
      color: background == null ? color : null,
      decoration:
          background == null ? null : BoxDecoration(gradient: background),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _contentWidth),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontal,
              topPadding * verticalScale,
              horizontal,
              bottomPadding * verticalScale,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.number,
    required this.eyebrow,
    required this.title,
    required this.description,
  });

  final String number;
  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 820;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: _mint,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 32, height: 1, color: _mint),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    eyebrow,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: TextStyle(
                color: _text,
                fontSize: wide ? 48 : 37,
                height: 1.08,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.25,
              ),
            ),
          ],
        );
        final body = Text(
          description,
          style: const TextStyle(color: _muted, fontSize: 16, height: 1.65),
        );
        return wide
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 11, child: heading),
                const SizedBox(width: 54),
                Expanded(flex: 7, child: body),
              ],
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [heading, const SizedBox(height: 20), body],
            );
      },
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: _mint.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _mint.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: _mint,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: _mint,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.expand = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: _mint,
        foregroundColor: _onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.expand = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 17),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: _text,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        side: const BorderSide(color: _line),
        textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class _SmallCta extends StatelessWidget {
  const _SmallCta({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        backgroundColor: _mint,
        foregroundColor: _onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
      ),
      child: Text(label),
    );
  }
}

class _SocialPill extends StatelessWidget {
  const _SocialPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: _inkSoft,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: _line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: _muted, size: 13),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  const _StoreButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: _text,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        side: const BorderSide(color: _line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color.lerp(color, _text, 0.42),
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _HoverLift extends StatefulWidget {
  const _HoverLift({required this.child, this.distance = 7});

  final Widget child;
  final double distance;

  @override
  State<_HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<_HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          _hovered ? -widget.distance : 0,
          0,
        ),
        child: widget.child,
      ),
    );
  }
}
