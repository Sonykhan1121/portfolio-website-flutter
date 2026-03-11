import 'package:flutter/material.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../intro/data/services/url_launcher_service.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';
import '../widgets/competency_tag.dart';
import '../widgets/platform_button.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding, vertical: context.verticalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              NumberWithTitle(number: "01", title: "About Me"),
              SizedBox(height: context.sectionSpacing),

              // Main Description
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'I am a passionate Flutter Software Developer with a strong foundation in building cross-platform applications. My focus is on creating clean, scalable, and user-centric solutions that deliver exceptional experiences across all platforms.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.descriptionFontSize,
                      height: 1.8,
                      color: Colors.black.withValues(alpha: 0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: context.elementSpacing),
                  Text(
                    'I care a lot about how code is structured, not just whether it works. Good architecture, reusable components, and readable code aren\'t just nice-to-haves for me — they\'re how I respect the next developer who touches the project (sometimes that\'s future me).',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.descriptionFontSize,
                      height: 1.8,
                      color: Colors.black.withValues(alpha: 0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: context.elementSpacing),
                  Text(
                    'I am constantly learning and exploring new technologies to stay at the forefront of cross-platform development, while delivering polished products that users love.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.descriptionFontSize,
                      height: 1.8,
                      color: Colors.black.withValues(alpha: 0.7),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.sectionSpacing),

              // Platforms Section Title
              Text(
                'PLATFORMS I BUILD FOR',
                style: TextStyle(
                  fontSize: context.sectionTitleFontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),

              SizedBox(height: context.sectionSpacing * 0.7),

              // Platform Buttons Grid - Responsive
              if (context.isMobile)
                // Single column layout for mobile
                Column(
                  children: [
                    PlatformButton(
                      icon: Icon(FontAwesomeIcons.android, color: DColors.primaryColor, size: 24),
                      label: 'Android',
                      onTap: () {
                        UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/android");
                      },
                      height: context.platformButtonHeight,
                      fontSize: context.platformLabelFontSize,
                    ),
                    SizedBox(height: context.platformSpacing),
                    PlatformButton(
                      icon: Icon(FontAwesomeIcons.apple, color: DColors.primaryColor, size: 24),
                      label: 'iOS',
                      onTap: () {
                        UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/ios");
                      },
                      height: context.platformButtonHeight,
                      fontSize: context.platformLabelFontSize,
                    ),
                    SizedBox(height: context.platformSpacing),
                    PlatformButton(
                      icon: Icon(FontAwesomeIcons.internetExplorer, color: DColors.primaryColor, size: 24),
                      label: 'Web',
                      onTap: () {
                        UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/web");
                      },
                      height: context.platformButtonHeight,
                      fontSize: context.platformLabelFontSize,
                    ),
                    SizedBox(height: context.platformSpacing),
                    PlatformButton(
                      icon: Icon(FontAwesomeIcons.windows, color: DColors.primaryColor, size: 24),
                      label: 'Windows',
                      onTap: () {
                        UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/windows");
                      },
                      height: context.platformButtonHeight,
                      fontSize: context.platformLabelFontSize,
                    ),
                    SizedBox(height: context.platformSpacing),
                    PlatformButton(
                      icon: Icon(FontAwesomeIcons.linux, color: DColors.primaryColor, size: 24),
                      label: 'Linux',
                      onTap: () {
                        UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/Linux");
                      },
                      height: context.platformButtonHeight,
                      fontSize: context.platformLabelFontSize,
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
                          child: PlatformButton(
                            icon: Image.asset(
                              'assets/icons/android_tag.png',
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                            ),
                            label: 'Android',
                            onTap: () {},
                            height: context.platformButtonHeight,
                            fontSize: context.platformLabelFontSize,
                          ),
                        ),
                        SizedBox(width: context.platformSpacing),
                        Expanded(
                          child: PlatformButton(
                            icon: Icon(Icons.phone_iphone, color: DColors.primaryColor, size: 24),
                            label: 'iOS',
                            onTap: () {},
                            height: context.platformButtonHeight,
                            fontSize: context.platformLabelFontSize,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.platformSpacing),
                    // Row 2: Web & Desktop
                    Row(
                      children: [
                        Expanded(
                          child: PlatformButton(
                            icon: Icon(Icons.language, color: DColors.primaryColor, size: 24),
                            label: 'Web',
                            onTap: () {},
                            height: context.platformButtonHeight,
                            fontSize: context.platformLabelFontSize,
                          ),
                        ),
                        SizedBox(width: context.platformSpacing),
                        Expanded(
                          child: PlatformButton(
                            icon: Icon(Icons.desktop_mac_outlined, color: DColors.primaryColor, size: 24),
                            label: 'Desktop',
                            onTap: () {},
                            height: context.platformButtonHeight,
                            fontSize: context.platformLabelFontSize,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              SizedBox(height: context.sectionSpacing),

              // Core Competencies Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'CORE COMPETENCIES',
                    style: TextStyle(
                      fontSize: context.sectionTitleFontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.black.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: context.sectionSpacing * 0.7),
                  // Competencies Grid - Responsive
                  Wrap(
                    spacing: context.isMobile ? 10.0 : 12.0,
                    runSpacing: context.isMobile ? 10.0 : 12.0,
                    alignment: WrapAlignment.center,
                    children: [
                      CompetencyTag(label: 'Flutter', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'Dart', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'State Management', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'REST APIs', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'Firebase', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'SQL/NoSQL', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'Git/GitHub', fontSize: context.competencyFontSize),
                      CompetencyTag(label: 'Clean Architecture', fontSize: context.competencyFontSize),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
