import 'package:flutter/material.dart';
import '../widgets/action_status.dart';
import '../widgets/social_icon_button.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/shared/custom_button.dart';
import '../../data/services/url_launcher_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroPage extends StatefulWidget {
  final bool isMobile;
  final dynamic dynamicRadius;
  final Function(int) scrollToSection;

  const IntroPage({
    super.key,
    required this.dynamicRadius,
    required this.isMobile,
    required this.scrollToSection,
  });

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 7 staggered items: avatar, status, name, title, description, socials, buttons
  late List<Animation<double>> _fadeAnims;
  late List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Stagger intervals — each item starts slightly after the previous
    final intervals = [
      const Interval(0.00, 0.30, curve: Curves.easeOut),
      const Interval(0.10, 0.38, curve: Curves.easeOut),
      const Interval(0.20, 0.48, curve: Curves.easeOut),
      const Interval(0.28, 0.56, curve: Curves.easeOut),
      const Interval(0.36, 0.64, curve: Curves.easeOut),
      const Interval(0.50, 0.75, curve: Curves.easeOut),
      const Interval(0.62, 0.88, curve: Curves.easeOut),
    ];

    _fadeAnims = intervals
        .map((interval) => Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: interval),
    ))
        .toList();

    _slideAnims = intervals
        .map((interval) => Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: interval),
    ))
        .toList();

    // Auto-play on mount
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Wraps a child with fade + slide animation at the given [index]
  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(
        position: _slideAnims[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.elementSpacing * 0.5),

        // 0 — Avatar
        _animated(
          0,
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: DColors.primaryDark.withValues(alpha: 0.2),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: DColors.primaryDark.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: CircleAvatar(
              radius: widget.dynamicRadius.clamp(50.0, 100.0),
              backgroundImage: const AssetImage('assets/images/me_edit.png'),
            ),
          ),
        ),

        SizedBox(height: context.elementSpacing),

        // 1 — Status badge
        _animated(1, ActionStatus(title: 'Available for opportunities')),

        SizedBox(height: context.sectionSpacing),

        // 2 — Name
        _animated(
          2,
          Text(
            'Sidratul Montaha',
            style: TextStyle(
              fontSize: Sizes.h1(context),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),

        SizedBox(height: context.elementSpacing * 0.5),

        // 3 — Title / role
        _animated(
          3,
          Text(
            'Flutter Software Developer',
            style: TextStyle(
              fontSize: Sizes.h4(context),
              fontWeight: FontWeight.w600,
              color: DColors.primaryLight,
              letterSpacing: 0.3,
            ),
          ),
        ),

        SizedBox(height: context.sectionSpacing),

        // 4 — Description
        _animated(
          4,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                      text: "I build beautiful, performant cross-platform applications for "),
                  TextSpan(
                    text: "Android",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: DColors.primaryDark),
                  ),
                  const TextSpan(text: ", "),
                  TextSpan(
                    text: "iOS",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: DColors.primaryDark),
                  ),
                  const TextSpan(text: ", "),
                  TextSpan(
                    text: "Web",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: DColors.primaryDark),
                  ),
                  const TextSpan(text: ", and "),
                  TextSpan(
                    text: "Desktop",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: DColors.primaryDark),
                  ),
                  const TextSpan(
                      text:
                      ". Turning ideas into polished digital experiences with clean code and thoughtful design."),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.descriptionFontSize,
                height: 1.6,
                color: Colors.black.withValues(alpha: 0.7),
              ),
            ),
          ),
        ),

        SizedBox(height: context.sectionSpacing),

        // 5 — Social icons
        _animated(
          5,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIconButton(
                assetPath: 'assets/icons/git_tag.png',
                url: 'https://github.com',
                tooltip: 'GitHub',
                onTap: () => UrlLauncherService.launchExternal(
                    'https://github.com/sonykhan1121'),
              ),
              SizedBox(width: context.elementSpacing),
              SocialIconButton(
                assetPath: 'assets/icons/linkedin.png',
                url: 'https://linkedin.com',
                tooltip: 'LinkedIn',
                onTap: () => UrlLauncherService.launchExternal(
                    'https://www.linkedin.com/in/sidratul-montaha-441b80175/'),
              ),
              SizedBox(width: context.elementSpacing),
              SocialIconButton(
                assetPath: 'assets/icons/twitter.png',
                url: 'https://twitter.com',
                tooltip: 'Twitter',
                onTap: () => UrlLauncherService.launchExternal(
                    'https://twitter.com/sonykhan1121'),
              ),
              SizedBox(width: context.elementSpacing),
              SocialIconButton(
                assetPath: 'assets/icons/facebook_logo.png',
                url: 'https://facebook.com',
                tooltip: 'Facebook',
                onTap: () => UrlLauncherService.launchExternal(
                    'https://facebook.com/sonykhan1121'),
              ),
            ],
          ),
        ),

        SizedBox(height: context.sectionSpacing * 1.25),

        // 6 — CTA Buttons
        _animated(
          6,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  direction: widget.isMobile ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: CustomButton(
                        text: 'Download CV',
                        backgroundColor: DColors.primaryDark,
                        sIcon: const Icon(FontAwesomeIcons.download,
                            color: DColors.white),
                        onTap: () {
                          UrlLauncherService.launchExternal(
                              'https://drive.google.com/file/d/1XjZ2kmgI1k1DLG87sAyArOjTcd1m9OW5/view?usp=sharing');
                        },
                        width: 240,
                        shadows: [
                          BoxShadow(
                            color: DColors.primaryDark.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                        width: context.elementSpacing * 0.5,
                        height: context.elementSpacing * 0.5),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: CustomButton(
                        text: 'Send Message',
                        backgroundColor: Colors.transparent,
                        width: 240,
                        sIcon:
                        const Icon(Icons.send, color: DColors.primaryDark),
                        textColor: DColors.primaryDark,
                        border: const BorderSide(
                            color: DColors.primaryDark, width: 2),
                        onTap: () => widget.scrollToSection(5),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        SizedBox(height: context.verticalPadding),
      ],
    );
  }
}