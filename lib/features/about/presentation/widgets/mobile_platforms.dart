import 'hover_platform_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../intro/data/services/url_launcher_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';

class MobilePlatforms extends StatelessWidget {
  final BuildContext context;
  const MobilePlatforms({required this.context});

  @override
  Widget build(BuildContext _) {
    final platforms = platformList(context);
    return Column(
      children: platforms
          .map((p) => Padding(
        padding: EdgeInsets.only(bottom: context.platformSpacing),
        child: p,
      ))
          .toList(),
    );
  }
}

List<Widget> platformList(BuildContext context) => [
  HoverPlatformButton(
    icon: Image.asset('assets/icons/android_tag.png', height: 24, width: 24, fit: BoxFit.contain),
    label: 'Android',
    onTap: () => UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/android"),
    height: context.platformButtonHeight,
    fontSize: context.platformLabelFontSize,
  ),
  HoverPlatformButton(
    icon: Icon(Icons.phone_iphone, color: DColors.primaryColor, size: 24),
    label: 'iOS',
    onTap: () => UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/ios"),
    height: context.platformButtonHeight,
    fontSize: context.platformLabelFontSize,
  ),
  HoverPlatformButton(
    icon: Icon(Icons.language, color: DColors.primaryColor, size: 24),
    label: 'Web',
    onTap: () => UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/web"),
    height: context.platformButtonHeight,
    fontSize: context.platformLabelFontSize,
  ),
  HoverPlatformButton(
    icon: Icon(FontAwesomeIcons.windows, color: DColors.primaryColor, size: 22),
    label: 'Windows',
    onTap: () => UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/windows"),
    height: context.platformButtonHeight,
    fontSize: context.platformLabelFontSize,
  ),
  HoverPlatformButton(
    icon: Icon(FontAwesomeIcons.linux, color: DColors.primaryColor, size: 22),
    label: 'Linux',
    onTap: () => UrlLauncherService.launchExternal("https://docs.flutter.dev/deployment/linux"),
    height: context.platformButtonHeight,
    fontSize: context.platformLabelFontSize,
  ),
];
