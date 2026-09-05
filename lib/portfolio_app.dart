import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/portfolio_data.dart';
import 'models/repository_item.dart';
import 'models/repository_query.dart';
import 'services/github_repository_service.dart';
import 'widgets/screenshot_gallery.dart';

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
const _linkedinUrl = 'https://www.linkedin.com/in/sidratul-montaha-flutter/';
const _linkedinVideosUrl =
    'https://www.linkedin.com/in/sidratul-montaha-flutter/recent-activity/videos/';
const _cvUrl =
    'https://drive.google.com/file/d/1TYH92znM8dSZ3sKT0-bnlcENmEEHdIwg/view?usp=sharing';
const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.grozziie.printer';
const _appStoreUrl = 'https://apps.apple.com/us/app/grozziie/id6476171035';
const _email = 'sonykhan1121@gmail.com';
const _thtSpaceRoute = '/professional-journey/tht-space';
const _thtWebsiteUrl = 'https://www.printernoble.com';
const _thtLinkedInUrl = 'https://www.linkedin.com/company/thtuepz';
const _thtMapUrl =
    'https://www.google.com/maps/search/?api=1&query=Uttara+Export+Processing+Zone+Nilphamari+Bangladesh';
const _grozziieYoutubeUrl = 'https://www.youtube.com/@grozziie/videos';

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

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, this.repositoryService});

  final GitHubRepositoryService? repositoryService;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final SemanticsHandle _semantics;

  @override
  void initState() {
    super.initState();
    _semantics = SemanticsBinding.instance.ensureSemantics();
  }

  @override
  void dispose() {
    _semantics.dispose();
    super.dispose();
  }

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
        focusColor: _mint.withValues(alpha: 0.2),
        filledButtonTheme: FilledButtonThemeData(style: _keyboardButtonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: _keyboardButtonStyle,
        ),
        textButtonTheme: TextButtonThemeData(style: _keyboardButtonStyle),
        iconButtonTheme: IconButtonThemeData(style: _keyboardButtonStyle),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _text,
          displayColor: _text,
          fontFamily: 'Arial',
        ),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Color(0x6655D6BE),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':
            (context) =>
                PortfolioHome(repositoryService: widget.repositoryService),
        _thtSpaceRoute: (context) => const ThtSpacePage(),
      },
    );
  }
}

final _keyboardButtonStyle = ButtonStyle(
  side: WidgetStateProperty.resolveWith(
    (states) =>
        states.contains(WidgetState.focused)
            ? const BorderSide(color: _sky, width: 3)
            : null,
  ),
);

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key, this.repositoryService});

  final GitHubRepositoryService? repositoryService;

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with WidgetsBindingObserver {
  late final GitHubRepositoryService _repositoryService;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _heroKey = GlobalKey();
  final _workKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _demosKey = GlobalKey();
  final _archiveKey = GlobalKey();
  final _journeyKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _contactKey = GlobalKey();

  String _filter = 'All';
  String _query = '';
  String _activeSection = 'Home';
  RepositorySort _sort = RepositorySort.relevant;
  bool _featuredOnly = false;
  bool _showAllRepositories = false;
  late List<RepositoryItem> _repositories;
  bool _isSyncingRepositories = true;
  bool _repositorySyncFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_updateActiveSection);
    _repositoryService =
        widget.repositoryService ??
        GitHubRepositoryService(username: 'Sonykhan1121');
    _repositories = List<RepositoryItem>.of(repositories);
    _syncRepositories();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final target = key.currentContext;
    if (target == null) return;
    final box = target.findRenderObject() as RenderBox;
    final offset = (_scrollController.offset +
            box.localToGlobal(Offset.zero).dy -
            96)
        .clamp(0.0, _scrollController.position.maxScrollExtent);
    await _scrollController.animateTo(
      offset,
      duration:
          MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateActiveSection());
  }

  void _updateActiveSection() {
    if (!mounted || !_scrollController.hasClients) return;
    var active = 'Home';
    for (final section in [
      (_heroKey, 'Home'),
      (_workKey, 'Grozziie'),
      (_projectsKey, 'Projects'),
      (_demosKey, 'Demos'),
      (_archiveKey, 'Archive'),
      (_aboutKey, 'About'),
      (_contactKey, 'Contact'),
    ]) {
      final box = section.$1.currentContext?.findRenderObject();
      if (box is RenderBox &&
          box.hasSize &&
          box.localToGlobal(Offset.zero).dy <= 150) {
        active = section.$2;
      }
    }
    if (_scrollController.position.extentAfter < 8) active = 'Contact';
    if (active != _activeSection) setState(() => _activeSection = active);
  }

  Future<void> _syncRepositories() async {
    try {
      final liveRepositories = await _repositoryService.fetchPublicRepositories(
        fallbackRepositories: repositories,
      );
      if (!mounted) return;
      setState(() {
        _repositories = liveRepositories;
        _isSyncingRepositories = false;
        _repositorySyncFailed = false;
        if (_filter != 'All' &&
            !_repositories.any(
              (repository) => repository.language == _filter,
            )) {
          _filter = 'All';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isSyncingRepositories = false;
        _repositorySyncFailed = true;
      });
    }
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
                    label: 'Demos',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_demosKey);
                    },
                  ),
                  _MobileNavItem(
                    label: 'Archive',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      _scrollTo(_archiveKey);
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

  Set<String> get _featuredUrls =>
      featuredProjects.map((p) => p.url.toLowerCase()).toSet();

  List<RepositoryItem> get _filteredRepositories => queryRepositories(
    _repositories,
    query: _query,
    language: _filter,
    featuredOnly: _featuredOnly,
    featuredUrls: _featuredUrls,
    sort: _sort,
  );

  Map<String, int> get _filterCounts {
    final matching = queryRepositories(
      _repositories,
      query: _query,
      featuredOnly: _featuredOnly,
      featuredUrls: _featuredUrls,
    );
    return {
      'All': matching.length,
      for (final language in _repositoryLanguages)
        language: matching.where((repo) => repo.language == language).length,
    };
  }

  void _resetRepositoryFilters() => setState(() {
    _searchController.clear();
    _query = '';
    _filter = 'All';
    _featuredOnly = false;
    _sort = RepositorySort.relevant;
    _showAllRepositories = false;
  });

  List<String> get _repositoryLanguages {
    const preferredOrder = [
      'Dart',
      'Kotlin',
      'Java',
      'C++',
      'Python',
      'HTML',
      'JavaScript',
      'TypeScript',
      'Liquid',
      'Other',
    ];
    final languages = _repositories.map((repo) => repo.language).toSet();
    final ordered = preferredOrder.where(languages.contains).toList();
    ordered.addAll(
      languages.where((language) => !preferredOrder.contains(language)).toList()
        ..sort(),
    );
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 76),
                Container(
                  key: _heroKey,
                  child: _HeroSection(
                    repositoryCount: _repositories.length,
                    onExplore: () => _scrollTo(_workKey),
                    onRepositories: () => _scrollTo(_archiveKey),
                    onJourney: () => _scrollTo(_journeyKey),
                  ),
                ),
                Container(key: _workKey, child: const _GrozziieSection()),
                _FeaturedProjectsSection(key: _projectsKey),
                Container(key: _demosKey, child: const _ProjectDemosSection()),
                _RepositorySection(
                  key: _archiveKey,
                  searchController: _searchController,
                  selectedFilter: _filter,
                  repositories: _filteredRepositories,
                  repositoryLanguages: _repositoryLanguages,
                  showAll: _showAllRepositories,
                  isSyncing: _isSyncingRepositories,
                  syncFailed: _repositorySyncFailed,
                  sort: _sort,
                  featuredOnly: _featuredOnly,
                  filterCounts: _filterCounts,
                  onSort: (value) => setState(() => _sort = value),
                  onFeatured:
                      (value) => setState(() {
                        _featuredOnly = value;
                        _showAllRepositories = false;
                      }),
                  onClear:
                      () => setState(() {
                        _searchController.clear();
                        _query = '';
                        _showAllRepositories = false;
                      }),
                  onReset: _resetRepositoryFilters,
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
                Container(
                  key: _aboutKey,
                  child: _AboutSection(journeyKey: _journeyKey),
                ),
                Container(key: _contactKey, child: const _ContactSection()),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _NavigationBar(
              activeSection: _activeSection,
              onHome: () => _scrollTo(_heroKey),
              onWork: () => _scrollTo(_workKey),
              onProjects: () => _scrollTo(_projectsKey),
              onDemos: () => _scrollTo(_demosKey),
              onArchive: () => _scrollTo(_archiveKey),
              onAbout: () => _scrollTo(_aboutKey),
              onContact: () => _scrollTo(_contactKey),
              onMenu: _openMobileMenu,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.activeSection,
    required this.onHome,
    required this.onWork,
    required this.onProjects,
    required this.onDemos,
    required this.onArchive,
    required this.onAbout,
    required this.onContact,
    required this.onMenu,
  });

  final VoidCallback onHome;
  final VoidCallback onWork;
  final VoidCallback onProjects;
  final VoidCallback onDemos;
  final VoidCallback onArchive;
  final String activeSection;
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
                final compact = constraints.maxWidth < 1100;
                return Row(
                  children: [
                    _InteractiveCard(
                      semanticLabel: 'Home — Sidratul Montaha',
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
                    if (compact && activeSection != 'Home') ...[
                      const SizedBox(width: 16),
                      Text(
                        activeSection,
                        style: const TextStyle(
                          color: _mint,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (!compact) ...[
                      _NavLink(
                        label: 'Grozziie',
                        onTap: onWork,
                        active: activeSection == 'Grozziie',
                      ),
                      _NavLink(
                        label: 'Projects',
                        onTap: onProjects,
                        active: activeSection == 'Projects',
                      ),
                      _NavLink(
                        label: 'Demos',
                        onTap: onDemos,
                        active: activeSection == 'Demos',
                      ),
                      _NavLink(
                        label: 'Archive',
                        onTap: onArchive,
                        active: activeSection == 'Archive',
                      ),
                      _NavLink(
                        label: 'About',
                        onTap: onAbout,
                        active: activeSection == 'About',
                      ),
                      const SizedBox(width: 10),
                      Semantics(
                        selected: activeSection == 'Contact',
                        child: _SmallCta(label: 'Let’s talk', onTap: onContact),
                      ),
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
  const _NavLink({
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Semantics(
        selected: active,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: active ? const Color(0xFFE2F4EF) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? _mint : _muted,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
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
  const _HeroSection({
    required this.repositoryCount,
    required this.onExplore,
    required this.onRepositories,
    required this.onJourney,
  });

  final int repositoryCount;
  final VoidCallback onExplore;
  final VoidCallback onRepositories;
  final VoidCallback onJourney;

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
              _MetricStrip(
                repositoryCount: repositoryCount,
                onRepositories: onRepositories,
                onJourney: onJourney,
              ),
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
        Semantics(
          header: true,
          child: Text(
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
                      semanticLabel: 'Portrait of Sidratul Montaha',
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
  const _MetricStrip({
    required this.repositoryCount,
    required this.onRepositories,
    required this.onJourney,
  });

  final int repositoryCount;
  final VoidCallback onRepositories;
  final VoidCallback onJourney;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      (
        '50K+',
        'Grozziie Android downloads',
        'View on Google Play',
        () => _launch(_playStoreUrl),
      ),
      (
        '$repositoryCount',
        'Public GitHub repositories',
        'Browse the archive',
        onRepositories,
      ),
      (
        '2',
        'Live mobile platforms',
        'Choose your platform',
        () => _showPlatforms(context),
      ),
      (
        '2024',
        'Production engineering since',
        'My professional journey',
        onJourney,
      ),
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
                    (metric) => SizedBox(
                      width: width,
                      child: _InteractiveCard(
                        semanticLabel:
                            '${metric.$1} ${metric.$2}. ${metric.$3}',
                        onTap: metric.$4,
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
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
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      metric.$3,
                                      style: const TextStyle(
                                        color: _mint,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: _mint,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

void _showPlatforms(BuildContext context) {
  showDialog<void>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Grozziie on your platform'),
          content: const Text('Explore the published Android or iOS app.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
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
  );
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
                  const ScreenshotGallery(screenshots: screenshots),
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
                Flexible(
                  child: Text(
                    metric.$1,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
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

class ThtSpacePage extends StatelessWidget {
  const ThtSpacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 620;
    return Title(
      title: 'THT-Space Journey — Sidratul Montaha',
      color: _mint,
      child: Scaffold(
        backgroundColor: _ink,
        appBar: AppBar(
          backgroundColor: _ink.withValues(alpha: 0.98),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.12),
          leading: IconButton(
            tooltip: 'Back to portfolio',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: _text),
          ),
          titleSpacing: 4,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THT-SPACE',
                style: TextStyle(
                  color: _text,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.25,
                ),
              ),
              Text(
                'PROFESSIONAL JOURNEY',
                style: TextStyle(
                  color: _muted,
                  fontSize: 8.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          actions: [
            if (compact)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Company website',
                  onPressed: () => _launch(_thtWebsiteUrl),
                  icon: const Icon(Icons.language_rounded, color: _mint),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: () => _launch(_thtWebsiteUrl),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('Company website'),
                  style: TextButton.styleFrom(
                    foregroundColor: _mint,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              _ThtSpaceHero(),
              _ThtCompanyOverview(),
              _ThtProductsSection(),
              _ThtImpactSection(),
              _ThtVideoSection(),
              _TeamSection(),
              _ThtPageFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThtSpaceHero extends StatelessWidget {
  const _ThtSpaceHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF020617),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              return SizedBox(
                height: wide ? 650 : 540,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/company/tht-space-team-cover.jpg',
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.08),
                      semanticLabel: 'THT-Space software team',
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.45, 1],
                          colors: [
                            Color(0x14020617),
                            Color(0x65020617),
                            Color(0xF5020617),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: wide ? 54 : 22,
                      right: wide ? 54 : 22,
                      bottom: wide ? 54 : 34,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF0C1D31,
                              ).withValues(alpha: 0.84),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Text(
                              'CURRENT COMPANY · DEC 2024 — PRESENT',
                              style: TextStyle(
                                color: Color(0xFF8EE7D6),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.05,
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          Text(
                            'Building connected products\nwith the THT-Space team.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: wide ? 58 : 39,
                              height: 1.05,
                              fontWeight: FontWeight.w900,
                              letterSpacing: wide ? -1.8 : -1.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'My professional journey as a Software Engineer at Bangladesh’s first printer manufacturer.',
                            style: TextStyle(
                              color: const Color(0xFFD6E1EF),
                              fontSize: wide ? 17 : 14,
                              height: 1.55,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ThtCompanyOverview extends StatelessWidget {
  const _ThtCompanyOverview();

  @override
  Widget build(BuildContext context) {
    const facts = [
      ('2019', 'Founded'),
      ('201–500', 'Company size'),
      ('100%', 'Export oriented'),
      ('Nilphamari', 'Uttara EPZ'),
    ];
    return _SectionShell(
      color: _ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '01',
            eyebrow: 'ABOUT THT-SPACE',
            title: 'Hardware manufacturing,\nstrengthened by software.',
            description:
                'THT-Space Electrical Company Ltd. manufactures printing and attendance equipment in Bangladesh for customers across international markets.',
          ),
          const SizedBox(height: 38),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 820 ? 4 : 2;
              const gap = 14.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    facts
                        .map(
                          (fact) => Container(
                            width: width,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _panel,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: _line),
                              boxShadow: _softShadow,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fact.$1,
                                  style: const TextStyle(
                                    color: _text,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  fact.$2,
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PrimaryButton(
                label: 'Visit company website',
                icon: Icons.language_rounded,
                onTap: () => _launch(_thtWebsiteUrl),
              ),
              _OutlineButton(
                label: 'Follow on LinkedIn',
                icon: FontAwesomeIcons.linkedinIn,
                onTap: () => _launch(_thtLinkedInUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThtProductsSection extends StatelessWidget {
  const _ThtProductsSection();

  @override
  Widget build(BuildContext context) {
    const products = [
      (
        Icons.receipt_long_rounded,
        'Thermal printers',
        'Compact printing equipment for retail, logistics, and everyday business operations.',
      ),
      (
        Icons.print_rounded,
        'Dot-matrix printers',
        'Reliable printing hardware designed for high-volume and operational environments.',
      ),
      (
        Icons.fact_check_rounded,
        'Attendance systems',
        'Connected attendance devices supported by mobile and cloud-based workflows.',
      ),
      (
        Icons.menu_book_rounded,
        'Binding equipment',
        'Practical finishing equipment for office, education, and document workflows.',
      ),
    ];
    return _SectionShell(
      color: _inkSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '02',
            eyebrow: 'WHAT THE COMPANY BUILDS',
            title: 'Printing, attendance,\nand connected equipment.',
            description:
                'The company combines manufacturing experience with software-enabled products and exports equipment to markets across Asia.',
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900 ? 4 : 2;
              final mobile = constraints.maxWidth < 620;
              final actualColumns = mobile ? 1 : columns;
              const gap = 16.0;
              final width =
                  (constraints.maxWidth - gap * (actualColumns - 1)) /
                  actualColumns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    products
                        .map(
                          (product) => Container(
                            width: width,
                            constraints: const BoxConstraints(minHeight: 235),
                            padding: const EdgeInsets.all(23),
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
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF087F6B), _sky],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    product.$1,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  product.$2,
                                  style: const TextStyle(
                                    color: _text,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  product.$3,
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 13.5,
                                    height: 1.55,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: _sky.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _sky.withValues(alpha: 0.18)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.public_rounded, color: _sky, size: 22),
                SizedBox(width: 13),
                Expanded(
                  child: Text(
                    'Export reach includes markets such as China, Malaysia, Thailand, Indonesia, Singapore, and the Philippines.',
                    style: TextStyle(
                      color: _text,
                      fontSize: 13.5,
                      height: 1.55,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThtImpactSection extends StatelessWidget {
  const _ThtImpactSection();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: const LinearGradient(
        colors: [Color(0xFFF3FAF8), Color(0xFFF5F7FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '03',
            eyebrow: 'MY ROLE & PRODUCT IMPACT',
            title: 'Software that connects\npeople, printers, and data.',
            description:
                'My work focuses on production Flutter applications, device communication, reliable business workflows, and releases across Android and iOS.',
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 900;
              final role = Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: _panel,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: _line),
                  boxShadow: _cardShadow,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Eyebrow(label: 'SOFTWARE ENGINEER'),
                    SizedBox(height: 22),
                    Text(
                      'What I contribute',
                      style: TextStyle(
                        color: _text,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                    ),
                    SizedBox(height: 20),
                    _ThtImpactPoint(
                      icon: Icons.phone_android_rounded,
                      title: 'Cross-platform delivery',
                      description:
                          'Production Flutter features for Android and iOS, from reusable UI to release workflows.',
                    ),
                    _ThtImpactPoint(
                      icon: Icons.bluetooth_connected_rounded,
                      title: 'Hardware integration',
                      description:
                          'Bluetooth, IoT, printer communication, real-time connections, and device-focused workflows.',
                    ),
                    _ThtImpactPoint(
                      icon: Icons.face_retouching_natural_rounded,
                      title: 'Attendance intelligence',
                      description:
                          'Face-attendance experiences, REST APIs, WebSockets, Firebase, and offline-aware data flows.',
                    ),
                    _ThtImpactPoint(
                      icon: Icons.account_tree_rounded,
                      title: 'Maintainable engineering',
                      description:
                          'Clean boundaries, state management, testing, Git workflows, and CI/CD practices.',
                      isLast: true,
                    ),
                  ],
                ),
              );
              const product = _GrozziieCompanyCard();
              return wide
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 9, child: role),
                      const SizedBox(width: 18),
                      const Expanded(flex: 11, child: product),
                    ],
                  )
                  : Column(
                    children: [role, const SizedBox(height: 18), product],
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _ThtImpactPoint extends StatelessWidget {
  const _ThtImpactPoint({
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _mint.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _mint, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GrozziieCompanyCard extends StatelessWidget {
  const _GrozziieCompanyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF101827),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2B3A50)),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/projects/grozziie/icon.webp',
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  semanticLabel: 'Grozziie app icon',
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grozziie',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'FLAGSHIP MOBILE PRODUCT',
                      style: TextStyle(
                        color: Color(0xFF8EE7D6),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            'A production printing companion for connected devices, business workflows, and everyday users across Android and iOS.',
            style: TextStyle(
              color: Color(0xFFC4D1E2),
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 22),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _DarkMetric(value: '50K+', label: 'Users'),
              _DarkMetric(value: '2', label: 'Platforms'),
              _DarkMetric(value: 'Live', label: 'Production'),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              const assets = [
                'assets/images/projects/grozziie/play_01.webp',
                'assets/images/projects/grozziie/play_03.webp',
                'assets/images/projects/grozziie/ios_01.jpg',
              ];
              const gap = 10.0;
              final width = (constraints.maxWidth - gap * 2) / 3;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    assets
                        .map(
                          (asset) => Padding(
                            padding: EdgeInsets.only(
                              right: asset == assets.last ? 0 : gap,
                            ),
                            child: SizedBox(
                              width: width,
                              child: AspectRatio(
                                aspectRatio: 0.52,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.asset(
                                    asset,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _DarkStoreButton(
                label: 'Google Play',
                icon: FontAwesomeIcons.googlePlay,
                onTap: () => _launch(_playStoreUrl),
              ),
              _DarkStoreButton(
                label: 'App Store',
                icon: FontAwesomeIcons.apple,
                onTap: () => _launch(_appStoreUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DarkMetric extends StatelessWidget {
  const _DarkMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFAEBED2),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkStoreButton extends StatelessWidget {
  const _DarkStoreButton({
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
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
    );
  }
}

class _ThtVideoSection extends StatelessWidget {
  const _ThtVideoSection();

  @override
  Widget build(BuildContext context) {
    const videos = [
      (
        '2-Inch Label Printer in Action',
        'PRODUCT DEMO · SHORT',
        'A quick look at compact label printing for product labels, price tags, and small businesses.',
        'assets/images/company/video-label-printer.jpg',
        'https://www.youtube.com/shorts/FRF4ZpNvxOM',
      ),
      (
        'More Than Shipping Labels',
        '4-INCH THERMAL PRINTER · SHORT',
        'See one printer handle shipping labels, product labels, stickers, barcodes, images, and more.',
        'assets/images/company/video-thermal-printer.jpg',
        'https://www.youtube.com/shorts/4kbaYefjaTc',
      ),
      (
        'Grozziie Software on macOS',
        'SOFTWARE WORKFLOW · GUIDE',
        'A complete product workflow covering software setup, printer configuration, and printing on macOS.',
        'assets/images/company/video-grozziie-macos.jpg',
        'https://www.youtube.com/watch?v=dH5zu0Sn2xc',
      ),
    ];
    return _SectionShell(
      color: _ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '04',
            eyebrow: 'OFFICIAL PRODUCT VIDEOS',
            title: 'See Grozziie\nin motion.',
            description:
                'Official product demonstrations and software guides show how Grozziie’s connected printing experience works beyond static screenshots.',
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns =
                  constraints.maxWidth >= 940
                      ? 3
                      : constraints.maxWidth >= 620
                      ? 2
                      : 1;
              const gap = 16.0;
              final width =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    videos
                        .map(
                          (video) => _ThtVideoCard(
                            width: width,
                            title: video.$1,
                            kicker: video.$2,
                            description: video.$3,
                            thumbnail: video.$4,
                            url: video.$5,
                          ),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () => _launch(_grozziieYoutubeUrl),
            icon: const Icon(FontAwesomeIcons.youtube, size: 17),
            label: const Text('Explore all Grozziie videos'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF0033),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
              textStyle: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w900,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThtVideoCard extends StatelessWidget {
  const _ThtVideoCard({
    required this.width,
    required this.title,
    required this.kicker,
    required this.description,
    required this.thumbnail,
    required this.url,
  });

  final double width;
  final String title;
  final String kicker;
  final String description;
  final String thumbnail;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: _InteractiveCard(
          semanticLabel:
              'Watch $title on YouTube — opens a new tab. $description',
          borderRadius: BorderRadius.circular(22),
          onTap: () => _launch(url),
          child: Container(
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _line),
              boxShadow: _cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        thumbnail,
                        fit: BoxFit.cover,
                        semanticLabel: '$title video preview',
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0x70000000)],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF0033),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.85),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 33,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kicker,
                        style: const TextStyle(
                          color: _mint,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.youtube,
                            color: Color(0xFFFF0033),
                            size: 15,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'WATCH ON YOUTUBE',
                            style: TextStyle(
                              color: _text,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_outward_rounded,
                            color: _muted,
                            size: 17,
                          ),
                        ],
                      ),
                    ],
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

class _ThtPageFooter extends StatelessWidget {
  const _ThtPageFooter();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      color: _inkSoft,
      topPadding: 72,
      bottomPadding: 72,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 650 ? 25 : 42,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE7F7F3), Color(0xFFEDF2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFBFDCD6)),
          boxShadow: _cardShadow,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Eyebrow(label: 'VERIFIED COMPANY LINKS'),
                const SizedBox(height: 17),
                Text(
                  'Discover THT-Space\nand the work behind it.',
                  style: TextStyle(
                    color: _text,
                    fontSize: wide ? 37 : 31,
                    height: 1.08,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 13),
                const Text(
                  'Uttara Export Processing Zone, Nilphamari, Bangladesh',
                  style: TextStyle(color: _muted, fontSize: 14, height: 1.55),
                ),
              ],
            );
            final links = Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _PrimaryButton(
                  label: 'Company website',
                  icon: Icons.language_rounded,
                  onTap: () => _launch(_thtWebsiteUrl),
                ),
                _OutlineButton(
                  label: 'LinkedIn',
                  icon: FontAwesomeIcons.linkedinIn,
                  onTap: () => _launch(_thtLinkedInUrl),
                ),
                _OutlineButton(
                  label: 'YouTube',
                  icon: FontAwesomeIcons.youtube,
                  onTap: () => _launch(_grozziieYoutubeUrl),
                ),
                _OutlineButton(
                  label: 'View location',
                  icon: Icons.location_on_outlined,
                  onTap: () => _launch(_thtMapUrl),
                ),
                _OutlineButton(
                  label: 'Back to portfolio',
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            );
            return wide
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 7, child: copy),
                    const SizedBox(width: 40),
                    Expanded(flex: 8, child: links),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [copy, const SizedBox(height: 24), links],
                );
          },
        ),
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      background: const LinearGradient(
        colors: [Color(0xFF020617), Color(0xFF07162C), Color(0xFF041224)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _GalaxySectionHeader(),
          const SizedBox(height: 46),
          const _SolarTeamLayout(),
        ],
      ),
    );
  }
}

class _GalaxySectionHeader extends StatelessWidget {
  const _GalaxySectionHeader();

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
                const Text(
                  '05',
                  style: TextStyle(
                    color: Color(0xFFFFC857),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 32, height: 1, color: const Color(0xFFFFC857)),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'OUR COMPANY GALAXY · THT-SPACE',
                    style: TextStyle(
                      color: Color(0xFF9FB2CE),
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
              'One vision at the center.\nEvery specialist in orbit.',
              style: TextStyle(
                color: Colors.white,
                fontSize: wide ? 48 : 37,
                height: 1.08,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.25,
              ),
            ),
          ],
        );
        const body = Text(
          'Zhang Geng is the guiding force at the center, while our web, design, software, quality, and backend specialists move together around one shared mission.',
          style: TextStyle(
            color: Color(0xFFB6C4D8),
            fontSize: 16,
            height: 1.65,
          ),
        );
        return wide
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(flex: 11, child: heading),
                const SizedBox(width: 54),
                const Expanded(flex: 7, child: body),
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

class _SolarTeamLayout extends StatefulWidget {
  const _SolarTeamLayout();

  @override
  State<_SolarTeamLayout> createState() => _SolarTeamLayoutState();
}

class _SolarTeamLayoutState extends State<_SolarTeamLayout>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 72),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) {
      _orbitController.stop();
    } else if (!_orbitController.isAnimating) {
      _orbitController.repeat();
    }
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 960) {
          return const _MobileSolarSystem();
        }
        return _DesktopSolarSystem(animation: _orbitController);
      },
    );
  }
}

class _DesktopSolarSystem extends StatelessWidget {
  const _DesktopSolarSystem({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const height = 900.0;
        const planetWidth = 164.0;
        const planetHeight = 148.0;
        const sunWidth = 276.0;
        const sunHeight = 314.0;
        final width = constraints.maxWidth;
        final center = Offset(width / 2, height / 2);
        final outerRadius = (width - planetWidth - 20) / 2;
        final orbitRadii = <Size>[
          Size(math.min(width * 0.31, 330), 275),
          Size(math.min(width * 0.39, 420), 320),
          Size(math.min(outerRadius, 500), 370),
        ];
        const phases = <double>[
          0,
          math.pi,
          math.pi * 2 / 3,
          math.pi * 5 / 3,
          math.pi / 3,
          math.pi * 4 / 3,
        ];

        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
            gradient: const RadialGradient(
              center: Alignment(0.05, 0.02),
              radius: 0.9,
              colors: [Color(0xFF15345D), Color(0xFF08172B), Color(0xFF020817)],
              stops: [0, 0.48, 1],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 50,
                spreadRadius: -12,
                offset: Offset(0, 24),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GalaxyPainter(
                    center: center,
                    orbitRadii: orbitRadii,
                  ),
                ),
              ),
              Positioned(
                left: center.dx - sunWidth / 2,
                top: center.dy - sunHeight / 2,
                width: sunWidth,
                height: sunHeight,
                child: const _SunLeader(member: teamLeader),
              ),
              AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      for (var index = 0; index < currentTeam.length; index++)
                        Builder(
                          builder: (context) {
                            final orbitIndex = index ~/ 2;
                            final angle =
                                phases[index] + animation.value * math.pi * 2;
                            final radius = orbitRadii[orbitIndex];
                            return Positioned(
                              left:
                                  center.dx +
                                  math.cos(angle) * radius.width -
                                  planetWidth / 2,
                              top:
                                  center.dy +
                                  math.sin(angle) * radius.height -
                                  planetHeight / 2,
                              width: planetWidth,
                              height: planetHeight,
                              child: _PlanetNode(
                                member: currentTeam[index],
                                index: index,
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
              const Positioned(left: 24, bottom: 20, child: _OrbitLegend()),
            ],
          ),
        );
      },
    );
  }
}

class _MobileSolarSystem extends StatelessWidget {
  const _MobileSolarSystem();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF102D51), Color(0xFF061328), Color(0xFF020817)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 32,
            spreadRadius: -8,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _MobileStarsPainter()),
          ),
          Column(
            children: [
              const SizedBox(
                width: 244,
                height: 320,
                child: _SunLeader(member: teamLeader),
              ),
              const SizedBox(height: 18),
              const _OrbitLegend(),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 330 ? 2 : 1;
                  const gap = 12.0;
                  final itemWidth =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (var index = 0; index < currentTeam.length; index++)
                        SizedBox(
                          width: itemWidth,
                          height: 192,
                          child: _MobilePlanetCard(
                            member: currentTeam[index],
                            index: index,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SunLeader extends StatelessWidget {
  const _SunLeader({required this.member});

  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label:
          '${member.name}, ${member.role}, center of the THT-Space team galaxy',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFC857).withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: const Color(0xFFFFD978).withValues(alpha: 0.48),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFFFD56A),
                  size: 15,
                ),
                SizedBox(width: 7),
                Text(
                  'CENTER OF OUR GALAXY',
                  style: TextStyle(
                    color: Color(0xFFFFE4A3),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 192,
            height: 192,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFFD45F),
                  Color(0xFFFF7A18),
                ],
                stops: [0, 0.62, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x99FFB21C),
                  blurRadius: 46,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Color(0x66FF6B00),
                  blurRadius: 90,
                  spreadRadius: 12,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  member.image,
                  fit: BoxFit.cover,
                  semanticLabel: '${member.name} portrait',
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          Text(
            member.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            member.role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFFDA7D),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanetNode extends StatelessWidget {
  const _PlanetNode({required this.member, required this.index});

  final TeamMember member;
  final int index;

  static const palettes = <List<Color>>[
    [Color(0xFF57D7FF), Color(0xFF3158C9)],
    [Color(0xFFFF8DC7), Color(0xFF8B5CF6)],
    [Color(0xFF7CF2B6), Color(0xFF087F6B)],
    [Color(0xFFFFD66B), Color(0xFFFF7A18)],
    [Color(0xFFA8B5FF), Color(0xFF4F46E5)],
    [Color(0xFFFF9F7A), Color(0xFFEC4899)],
  ];

  @override
  Widget build(BuildContext context) {
    final palette = palettes[index % palettes.length];
    return _HoverLift(
      child: Semantics(
        container: true,
        label: '${member.name}, ${member.role}, orbiting THT-Space team member',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PlanetPortrait(
              member: member,
              palette: palette,
              showRing: index == 1 || index == 4,
              size: 82,
            ),
            const SizedBox(height: 7),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xE6132238),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: palette.first.withValues(alpha: 0.42),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFB9C7DB),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                    ),
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

class _MobilePlanetCard extends StatelessWidget {
  const _MobilePlanetCard({required this.member, required this.index});

  final TeamMember member;
  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = _PlanetNode.palettes[index % _PlanetNode.palettes.length];
    return Semantics(
      container: true,
      label: '${member.name}, ${member.role}, orbiting THT-Space team member',
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 13, 10, 11),
        decoration: BoxDecoration(
          color: const Color(0xB30E2038),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: palette.first.withValues(alpha: 0.42)),
        ),
        child: Column(
          children: [
            _PlanetPortrait(
              member: member,
              palette: palette,
              showRing: index == 1 || index == 4,
              size: 94,
            ),
            const SizedBox(height: 9),
            Text(
              member.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              member.role,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFB9C7DB),
                fontSize: 10.5,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanetPortrait extends StatelessWidget {
  const _PlanetPortrait({
    required this.member,
    required this.palette,
    required this.showRing,
    required this.size,
  });

  final TeamMember member;
  final List<Color> palette;
  final bool showRing;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 22,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showRing)
            Transform.rotate(
              angle: -0.18,
              child: Container(
                width: size + 20,
                height: size * 0.34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: palette.first.withValues(alpha: 0.75),
                    width: 3,
                  ),
                ),
              ),
            ),
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: palette),
              boxShadow: [
                BoxShadow(
                  color: palette.first.withValues(alpha: 0.48),
                  blurRadius: 24,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                member.image,
                fit: BoxFit.cover,
                semanticLabel: '${member.name} portrait',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitLegend extends StatelessWidget {
  const _OrbitLegend();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.blur_circular_rounded, color: Color(0xFF7DD3FC), size: 15),
          SizedBox(width: 7),
          Text(
            '6 SPECIALISTS · 3 ORBITS · 1 SHARED MISSION',
            style: TextStyle(
              color: Color(0xFFC5D4E8),
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.75,
            ),
          ),
        ],
      ),
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  const _GalaxyPainter({required this.center, required this.orbitRadii});

  final Offset center;
  final List<Size> orbitRadii;

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < 78; index++) {
      final x = ((index * 83) % 997) / 997 * size.width;
      final y = ((index * 149 + 37) % 701) / 701 * size.height;
      final radius = 0.7 + (index % 4) * 0.42;
      final opacity = 0.28 + (index % 3) * 0.16;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = Colors.white.withValues(alpha: opacity),
      );
    }

    for (var orbit = 0; orbit < orbitRadii.length; orbit++) {
      final radius = orbitRadii[orbit];
      final rect = Rect.fromCenter(
        center: center,
        width: radius.width * 2,
        height: radius.height * 2,
      );
      final paint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = orbit == 1 ? 1.25 : 1
            ..color = const Color(
              0xFF78D7FF,
            ).withValues(alpha: orbit == 1 ? 0.34 : 0.22);
      for (var angle = 0.0; angle < math.pi * 2; angle += 0.17) {
        canvas.drawArc(rect, angle, 0.105, false, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GalaxyPainter oldDelegate) =>
      oldDelegate.center != center || oldDelegate.orbitRadii != orbitRadii;
}

class _MobileStarsPainter extends CustomPainter {
  const _MobileStarsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    for (var index = 0; index < 52; index++) {
      final x = ((index * 61) % 383) / 383 * size.width;
      final y = ((index * 113 + 29) % 617) / 617 * size.height;
      canvas.drawCircle(
        Offset(x, y),
        0.7 + (index % 3) * 0.35,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.2 + (index % 3) * 0.12),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
            number: '03',
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
                            height: 394,
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
      child: _InteractiveCard(
        semanticLabel:
            'View ${project.title} on GitHub — opens a new tab. ${project.description} ${project.tags.join(', ')}',
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
                      FontAwesomeIcons.github,
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
              const SizedBox(height: 18),
              const Row(
                children: [
                  Text(
                    'View on GitHub',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.open_in_new, size: 15, color: _mint),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectDemosSection extends StatelessWidget {
  const _ProjectDemosSection();

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      color: _inkSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '04',
            eyebrow: 'PROJECT DEMOS',
            title: 'See the engineering\nin motion.',
            description:
                'Short, real-world demonstrations of computer vision, on-device AI, and Flutter products. Each preview opens the full video on LinkedIn.',
          ),
          const SizedBox(height: 42),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns =
                  constraints.maxWidth >= 980
                      ? 3
                      : constraints.maxWidth >= 650
                      ? 2
                      : 1;
              const gap = 20.0;
              final itemWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children:
                    projectDemos
                        .map(
                          (demo) => SizedBox(
                            width: itemWidth,
                            height: 446,
                            child: _ProjectDemoCard(demo: demo),
                          ),
                        )
                        .toList(),
              );
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: _OutlineButton(
              label: 'View all demos on LinkedIn',
              icon: Icons.video_library_outlined,
              onTap: () => _launch(_linkedinVideosUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectDemoCard extends StatelessWidget {
  const _ProjectDemoCard({required this.demo});

  final ProjectDemo demo;

  @override
  Widget build(BuildContext context) {
    return _HoverLift(
      child: Semantics(
        button: true,
        label: 'Watch ${demo.title} demo on LinkedIn',
        child: InkWell(
          onTap: () => _launch(demo.url),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _line),
              boxShadow: _cardShadow,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 202,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        demo.thumbnail,
                        fit: BoxFit.cover,
                        alignment: demo.thumbnailAlignment,
                        semanticLabel: '${demo.title} video preview',
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x29000000),
                              Color(0x00000000),
                              Color(0x8F000000),
                            ],
                            stops: [0, 0.52, 1],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A66C2),
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: _softShadow,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.linkedinIn,
                                size: 12,
                                color: Colors.white,
                              ),
                              SizedBox(width: 7),
                              Text(
                                'VIDEO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xD9111827),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            demo.duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 62,
                          height: 62,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.94),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.8),
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x4D000000),
                                blurRadius: 24,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: _mint,
                            size: 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          demo.kicker,
                          style: const TextStyle(
                            color: _mint,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          demo.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _text,
                            fontSize: 20,
                            height: 1.18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            demo.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 13.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                demo.tags.join('  •  '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: _muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'WATCH DEMO',
                              style: TextStyle(
                                color: _text,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.north_east_rounded,
                              color: _mint,
                              size: 17,
                            ),
                          ],
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

class _RepositorySection extends StatelessWidget {
  const _RepositorySection({
    super.key,
    required this.searchController,
    required this.selectedFilter,
    required this.repositories,
    required this.repositoryLanguages,
    required this.showAll,
    required this.isSyncing,
    required this.syncFailed,
    required this.onSearch,
    required this.onFilter,
    required this.onToggleAll,
    required this.sort,
    required this.featuredOnly,
    required this.filterCounts,
    required this.onSort,
    required this.onFeatured,
    required this.onClear,
    required this.onReset,
  });

  final TextEditingController searchController;
  final String selectedFilter;
  final List<RepositoryItem> repositories;
  final List<String> repositoryLanguages;
  final bool showAll;
  final bool isSyncing;
  final bool syncFailed;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;
  final VoidCallback onToggleAll;
  final RepositorySort sort;
  final bool featuredOnly;
  final Map<String, int> filterCounts;
  final ValueChanged<RepositorySort> onSort;
  final ValueChanged<bool> onFeatured;
  final VoidCallback onClear;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final filters = ['All', ...repositoryLanguages];
    final visible = showAll ? repositories : repositories.take(12).toList();

    return _SectionShell(
      color: _inkSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '05',
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
                    labelText: 'Search repositories',
                    suffixIcon:
                        searchController.text.isEmpty
                            ? null
                            : IconButton(
                              tooltip: 'Clear search',
                              onPressed: onClear,
                              icon: const Icon(Icons.close),
                            ),
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      filters
                          .map(
                            (filter) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  '$filter (${filterCounts[filter] ?? 0})',
                                ),
                                selected: selectedFilter == filter,
                                onSelected: (_) => onFilter(filter),
                                backgroundColor: _ink,
                                selectedColor: _mint,
                                side: BorderSide(
                                  color:
                                      selectedFilter == filter ? _mint : _line,
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
                const SizedBox(height: 18),
                Wrap(
                  spacing: 18,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 215,
                      child: DropdownButtonFormField<RepositorySort>(
                        isExpanded: true,
                        style: const TextStyle(color: _text, fontSize: 14),
                        value: sort,
                        decoration: const InputDecoration(
                          labelText: 'Sort repositories',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: RepositorySort.relevant,
                            child: Text('Most relevant'),
                          ),
                          DropdownMenuItem(
                            value: RepositorySort.newest,
                            child: Text('Newest created'),
                          ),
                          DropdownMenuItem(
                            value: RepositorySort.starred,
                            child: Text('Most starred'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) onSort(value);
                        },
                      ),
                    ),
                    FilterChip(
                      label: const Text('Featured only'),
                      selected: featuredOnly,
                      onSelected: onFeatured,
                      avatar: const Icon(Icons.auto_awesome, size: 17),
                    ),
                    if (searchController.text.isNotEmpty ||
                        selectedFilter != 'All' ||
                        featuredOnly ||
                        sort != RepositorySort.relevant)
                      TextButton.icon(
                        onPressed: onReset,
                        icon: const Icon(Icons.restart_alt, size: 18),
                        label: const Text('Reset filters'),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Semantics(
                liveRegion: true,
                child: Text(
                  '${repositories.length} repositories found',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isSyncing)
                      const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _mint,
                        ),
                      )
                    else
                      Icon(
                        syncFailed
                            ? Icons.cloud_off_rounded
                            : Icons.cloud_done_rounded,
                        color: syncFailed ? _muted : _mint,
                        size: 15,
                      ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isSyncing
                            ? 'Loading repository data…'
                            : syncFailed
                            ? 'Showing saved data'
                            : 'Auto-synced from GitHub',
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: _muted, fontSize: 11),
                      ),
                    ),
                  ],
                ),
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
              child: Column(
                children: [
                  const Icon(Icons.search_off_rounded, color: _muted, size: 34),
                  const SizedBox(height: 12),
                  const Text(
                    'No repositories match this search.',
                    style: TextStyle(color: _text, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onReset,
                    child: const Text('Clear all filters'),
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
                              height: 266,
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
      child: _InteractiveCard(
        semanticLabel:
            'View ${repo.name} on GitHub — opens a new tab. ${repo.description} ${repo.language}. Updated ${repo.updated}.${repo.stars == null ? '' : ' ${repo.stars} GitHub stars.'}',
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
                      FontAwesomeIcons.github,
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
                    'Updated ${repo.updated}',
                    style: const TextStyle(color: _muted, fontSize: 10.5),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'View repository',
                    style: TextStyle(
                      color: _mint,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.open_in_new, size: 14, color: _mint),
                  const Spacer(),
                  if (repo.stars != null) ...[
                    const Icon(
                      Icons.star_outline_rounded,
                      size: 16,
                      color: _muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${repo.stars}',
                      semanticsLabel: '${repo.stars} GitHub stars',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
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
  const _AboutSection({required this.journeyKey});
  final GlobalKey journeyKey;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      color: _ink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            number: '06',
            eyebrow: 'ABOUT & CAPABILITIES',
            title: 'Engineering across the\nwhole product journey.',
            description:
                'From responsive interfaces to device communication and production delivery, I focus on maintainable systems that feel simple to use.',
          ),
          const SizedBox(height: 42),
          const _CapabilityGrid(),
          const SizedBox(height: 72),
          Container(key: journeyKey, child: const _JourneySection()),
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
        final work = _JourneyCard(
          icon: Icons.work_outline_rounded,
          eyebrow: 'DEC 2024 — PRESENT',
          title: 'Software Engineer',
          subtitle: 'THT-Space Electrical Company Ltd. • Bangladesh',
          description:
              'Developing and maintaining production Flutter features across Android and iOS. My work spans Bluetooth and IoT, face-attendance workflows, REST APIs, WebSockets, Firebase, reusable UI, and CI/CD practices.',
          actionLabel: 'Explore THT-Space journey',
          onTap: () => Navigator.of(context).pushNamed(_thtSpaceRoute),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: work),
                  const SizedBox(width: 16),
                  const Expanded(child: education),
                ],
              )
            else
              Column(children: [work, const SizedBox(height: 16), education]),
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
    this.actionLabel,
    this.onTap,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String description;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      constraints: const BoxConstraints(minHeight: 346),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: onTap == null ? _line : _sky),
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
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      color: _sky,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                const Icon(Icons.arrow_forward_rounded, color: _sky, size: 18),
              ],
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: _InteractiveCard(
        semanticLabel: '$actionLabel. $title. $subtitle. $description',
        onTap: onTap!,
        borderRadius: BorderRadius.circular(22),
        child: card,
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
                      const SizedBox(height: 20),
                      const Text(
                        'Based in Bangladesh · UTC+6\nEmail is the best way to reach me.',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 13,
                          height: 1.7,
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
                      const SizedBox(height: 11),
                      _OutlineButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        onTap: () => _launch(_cvUrl),
                        expand: true,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () async {
                          try {
                            await Clipboard.setData(
                              const ClipboardData(text: _email),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Email address copied'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } catch (_) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Could not copy. Select the email address below to copy it manually.',
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy_rounded, size: 17),
                        label: const Text('Copy email address'),
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
            Semantics(
              header: true,
              child: Text(
                title,
                style: TextStyle(
                  color: _text,
                  fontSize: wide ? 48 : 37,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.25,
                ),
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
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: _mint,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.25,
              ),
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
      ).merge(_keyboardButtonStyle),
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
    return _InteractiveCard(
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
      ).merge(_keyboardButtonStyle),
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
      cursor: MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(
          0,
          _hovered && !MediaQuery.disableAnimationsOf(context)
              ? -widget.distance
              : 0,
          0,
        ),
        child: widget.child,
      ),
    );
  }
}

/// An overlay keeps keyboard focus visible even over opaque card artwork.
class _InteractiveCard extends StatefulWidget {
  const _InteractiveCard({
    required this.child,
    required this.onTap,
    required this.borderRadius,
    this.semanticLabel,
  });
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final String? semanticLabel;
  @override
  State<_InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<_InteractiveCard> {
  bool _focused = false;
  bool _hovered = false;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: widget.semanticLabel,
    onTap: widget.semanticLabel == null ? null : widget.onTap,
    excludeSemantics: widget.semanticLabel != null,
    child: InkWell(
      onTap: widget.onTap,
      borderRadius: widget.borderRadius,
      onFocusChange: (value) => setState(() => _focused = value),
      onHover: (value) => setState(() => _hovered = value),
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color:
                        _focused
                            ? _sky
                            : _hovered
                            ? _mint
                            : Colors.transparent,
                    width: _focused ? 3 : 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
