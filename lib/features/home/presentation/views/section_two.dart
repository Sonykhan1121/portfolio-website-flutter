import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/break_points.dart';
import '../widgets/number_with_title.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < Breakpoints.mobile;
        final isTablet = screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;

        // Dynamic font sizes
        final descriptionFontSize = isMobile ? 14.0 : isTablet ? 15.0 : 16.0;
        final sectionTitleFontSize = isMobile ? 11.0 : 12.0;
        final platformLabelFontSize = isMobile ? 13.0 : 15.0;
        final competencyFontSize = isMobile ? 12.0 : 13.0;

        // Dynamic padding
        final horizontalPadding = isMobile ? 16.0 : 20.0;
        final verticalPadding = isMobile ? 40.0 : 60.0;
        final sectionSpacing = isMobile ? 30.0 : 40.0;
        final elementSpacing = isMobile ? 20.0 : 24.0;

        // Dynamic grid layout
        final platformButtonHeight = isMobile ? 100.0 : 120.0;
        final platformSpacing = isMobile ? 12.0 : 16.0;

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  NumberWithTitle(number: "01", title: "About Me"),
                  SizedBox(height: sectionSpacing),

                  // Main Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'I am a passionate Flutter Software Developer with a strong foundation in building cross-platform applications. My focus is on creating clean, scalable, and user-centric solutions that deliver exceptional experiences across all platforms.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          height: 1.8,
                          color: Colors.black.withValues(alpha: 0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: elementSpacing),
                      Text(
                        'With expertise in Dart and the Flutter framework, I specialize in developing applications that run seamlessly on Android, iOS, Web, and Desktop from a single codebase. I value clean architecture, reusable components, and maintainable code.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          height: 1.8,
                          color: Colors.black.withValues(alpha: 0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: elementSpacing),
                      Text(
                        'I am constantly learning and exploring new technologies to stay at the forefront of cross-platform development, while delivering polished products that users love.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          height: 1.8,
                          color: Colors.black.withValues(alpha: 0.7),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sectionSpacing),

                  // Platforms Section Title
                  Text(
                    'PLATFORMS I BUILD FOR',
                    style: TextStyle(
                      fontSize: sectionTitleFontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),

                  SizedBox(height: sectionSpacing * 0.7),

                  // Platform Buttons Grid - Responsive
                  if (isMobile)
                    // Single column layout for mobile
                    Column(
                      children: [
                        _PlatformButton(
                          icon: Image.asset(
                            'assets/icons/android_tag.png',
                            height: 24,
                            width: 24,
                            fit: BoxFit.contain,
                          ),
                          label: 'Android',
                          onTap: () {},
                          height: platformButtonHeight,
                          fontSize: platformLabelFontSize,
                        ),
                        SizedBox(height: platformSpacing),
                        _PlatformButton(
                          icon: Icon(
                            Icons.phone_iphone,
                            color: DColors.primaryColor,
                            size: 24,
                          ),
                          label: 'iOS',
                          onTap: () {},
                          height: platformButtonHeight,
                          fontSize: platformLabelFontSize,
                        ),
                        SizedBox(height: platformSpacing),
                        _PlatformButton(
                          icon: Icon(
                            Icons.language,
                            color: DColors.primaryColor,
                            size: 24,
                          ),
                          label: 'Web',
                          onTap: () {},
                          height: platformButtonHeight,
                          fontSize: platformLabelFontSize,
                        ),
                        SizedBox(height: platformSpacing),
                        _PlatformButton(
                          icon: Icon(
                            Icons.desktop_mac_outlined,
                            color: DColors.primaryColor,
                            size: 24,
                          ),
                          label: 'Desktop',
                          onTap: () {},
                          height: platformButtonHeight,
                          fontSize: platformLabelFontSize,
                        ),
                      ],
                    )
                  else
                    // Grid layout for tablet and desktop
                    Column(
                      children: [
                        // Row 1: Android & iOS
                        Row(
                          children: [
                            Expanded(
                              child: _PlatformButton(
                                icon: Image.asset(
                                  'assets/icons/android_tag.png',
                                  height: 24,
                                  width: 24,
                                  fit: BoxFit.contain,
                                ),
                                label: 'Android',
                                onTap: () {},
                                height: platformButtonHeight,
                                fontSize: platformLabelFontSize,
                              ),
                            ),
                            SizedBox(width: platformSpacing),
                            Expanded(
                              child: _PlatformButton(
                                icon: Icon(
                                  Icons.phone_iphone,
                                  color: DColors.primaryColor,
                                  size: 24,
                                ),
                                label: 'iOS',
                                onTap: () {},
                                height: platformButtonHeight,
                                fontSize: platformLabelFontSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: platformSpacing),
                        // Row 2: Web & Desktop
                        Row(
                          children: [
                            Expanded(
                              child: _PlatformButton(
                                icon: Icon(
                                  Icons.language,
                                  color: DColors.primaryColor,
                                  size: 24,
                                ),
                                label: 'Web',
                                onTap: () {},
                                height: platformButtonHeight,
                                fontSize: platformLabelFontSize,
                              ),
                            ),
                            SizedBox(width: platformSpacing),
                            Expanded(
                              child: _PlatformButton(
                                icon: Icon(
                                  Icons.desktop_mac_outlined,
                                  color: DColors.primaryColor,
                                  size: 24,
                                ),
                                label: 'Desktop',
                                onTap: () {},
                                height: platformButtonHeight,
                                fontSize: platformLabelFontSize,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                  SizedBox(height: sectionSpacing),

                  // Core Competencies Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'CORE COMPETENCIES',
                        style: TextStyle(
                          fontSize: sectionTitleFontSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: Colors.black.withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: sectionSpacing * 0.7),
                      // Competencies Grid - Responsive
                      Wrap(
                        spacing: isMobile ? 10.0 : 12.0,
                        runSpacing: isMobile ? 10.0 : 12.0,
                        alignment: WrapAlignment.center,
                        children: [
                          _CompetencyTag(
                            label: 'Flutter',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'Dart',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'State Management',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'REST APIs',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'Firebase',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'SQL/NoSQL',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'Git/GitHub',
                            fontSize: competencyFontSize,
                          ),
                          _CompetencyTag(
                            label: 'Clean Architecture',
                            fontSize: competencyFontSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Platform Button Widget
class _PlatformButton extends StatefulWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  final double height;
  final double fontSize;

  const _PlatformButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.height = 120.0,
    this.fontSize = 15.0,
  });

  @override
  State<_PlatformButton> createState() => _PlatformButtonState();
}

class _PlatformButtonState extends State<_PlatformButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? DColors.primaryLight.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border.all(
              color: _isHovered
                  ? DColors.primaryLight
                  : DColors.primaryColor.withValues(alpha: 0.6),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: DColors.primaryLight.withValues(alpha: 0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [
                    BoxShadow(
                      color: DColors.primaryLight.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: widget.icon,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? DColors.primaryLight : DColors.primaryColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Competency Tag Widget
class _CompetencyTag extends StatefulWidget {
  final String label;
  final double fontSize;

  const _CompetencyTag({
    required this.label,
    this.fontSize = 13.0,
  });

  @override
  State<_CompetencyTag> createState() => _CompetencyTagState();
}

class _CompetencyTagState extends State<_CompetencyTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: _isHovered
              ? DColors.primaryLight.withValues(alpha: 0.15)
              : DColors.primaryLight.withValues(alpha: 0.08),
          border: Border.all(
            color: _isHovered
                ? DColors.primaryLight
                : DColors.primaryLight.withValues(alpha: 0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w500,
            color: _isHovered ? DColors.primaryLight : DColors.primaryDark,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
