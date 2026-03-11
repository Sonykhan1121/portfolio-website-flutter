import 'package:flutter/material.dart';
import '../widgets/action_status.dart';
import '../widgets/social_icon_button.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/shared/custom_button.dart';
import '../../data/services/url_launcher_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroPage extends StatelessWidget {
  final bool isMobile;
  final dynamic dynamicRadius;
  final Function(int) scrollToSection;
  const IntroPage({super.key, required this.dynamicRadius, required this.isMobile,required this.scrollToSection});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.elementSpacing * 0.5),
        // Profile Avatar with Border
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
            radius: dynamicRadius.clamp(50.0, 100.0),
            backgroundImage: const AssetImage('assets/images/me_edit.png'),
          ),
        ),
        SizedBox(height: context.elementSpacing),
        ActionStatus(title: 'Available for opportunities'),
        SizedBox(height: context.sectionSpacing),
        // Name
        Text(
          'Sidratul Montaha',
          style: TextStyle(
            fontSize: Sizes.h1(context),
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: context.elementSpacing * 0.5),
        // Title
        Text(
          'Flutter Software Developer',
          style: TextStyle(
            fontSize: Sizes.h4(context),
            fontWeight: FontWeight.w600,
            color: DColors.primaryLight,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: context.sectionSpacing),
        // Description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "I build beautiful, performant cross-platform applications for "),
                TextSpan(
                  text: "Android",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: DColors.primaryDark,
                  ),
                ),
                const TextSpan(text: ", "),
                TextSpan(
                  text: "iOS",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: DColors.primaryDark,
                  ),
                ),
                const TextSpan(text: ", "),
                TextSpan(
                  text: "Web",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: DColors.primaryDark,
                  ),
                ),
                const TextSpan(text: ", and "),
                TextSpan(
                  text: "Desktop",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: DColors.primaryDark,
                  ),
                ),
                const TextSpan(text: ". Turning ideas into polished digital experiences with clean code and thoughtful design."),
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
        SizedBox(height: context.sectionSpacing),
        // Social Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GitHub
            SocialIconButton(
              assetPath: 'assets/icons/git_tag.png',
              url: 'https://github.com',
              tooltip: 'GitHub',
              onTap: () => UrlLauncherService.launchExternal('https://github.com/sonykhan1121'),
            ),
            SizedBox(width: context.elementSpacing),
            // LinkedIn
            SocialIconButton(
              assetPath: 'assets/icons/linkedin.png',
              url: 'https://linkedin.com',
              tooltip: 'LinkedIn',
              onTap: () => UrlLauncherService.launchExternal('https://www.linkedin.com/in/sidratul-montaha-441b80175/'),
            ),
            SizedBox(width: context.elementSpacing),
            // Twitter
            SocialIconButton(
              assetPath: 'assets/icons/twitter.png',
              url: 'https://twitter.com',
              tooltip: 'Twitter',
              onTap: () => UrlLauncherService.launchExternal('https://twitter.com/sonykhan1121'),
            ),
            SizedBox(width: context.elementSpacing),
            // Facebook
            SocialIconButton(
              assetPath: 'assets/icons/facebook_logo.png',
              url: 'https://facebook.com',
              tooltip: 'Facebook',
              onTap: () => UrlLauncherService.launchExternal('https://facebook.com/sonykhan1121'),
            ),
          ],
        ),
        SizedBox(height: context.sectionSpacing * 1.25),
        // CTA Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CustomButton(
                      text: 'Download CV',
                      backgroundColor: DColors.primaryDark,
                      sIcon: const Icon(FontAwesomeIcons.download, color: DColors.white),
                      onTap: () {
                        UrlLauncherService.launchExternal('https://drive.google.com/file/d/1WgFLjGiwo5w_KoTn1QmgA6JGBabGbfNv/view?usp=sharing');
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
                  SizedBox(width: context.elementSpacing * 0.5, height: context.elementSpacing * 0.5),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CustomButton(
                      text: 'Send Message',
                      backgroundColor: Colors.transparent,
                      width: 240,
                      sIcon: const Icon(Icons.send, color: DColors.primaryDark),
                      textColor: DColors.primaryDark,
                      border: const BorderSide(color: DColors.primaryDark, width: 2),
                      onTap: ()=>scrollToSection(5),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: context.verticalPadding),
      ],
    );
  }
}

