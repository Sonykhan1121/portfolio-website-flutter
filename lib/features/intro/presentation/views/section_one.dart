import 'package:flutter/material.dart';
import '../widgets/action_status.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/shared/custom_button.dart';

class IntroPage extends StatelessWidget {
  final dynamic dynamicRadius;
  final bool isMobile;
  const IntroPage({super.key, required this.dynamicRadius, required this.isMobile});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
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
            backgroundImage: const AssetImage('assets/images/profilepic.png'),
          ),
        ),
        const SizedBox(height: 20),
        ActionStatus(title: 'Available for opportunities'),
        const SizedBox(height: 40),
        // Name
        const Text(
          'Sidratul Montaha',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
        const SizedBox(height: 10),
        // Title
        Text(
          'Flutter Software Developer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: DColors.primaryLight,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 40),
        // Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
              fontSize: 16,
              height: 1.6,
              color: Colors.black.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(height: 40),
        // Social Icons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GitHub
            _SocialIconButton(
              assetPath: 'assets/icons/git_tag.png',
              url: 'https://github.com',
              tooltip: 'GitHub',
              onTap: () => _launchURL('https://github.com'),
            ),
            const SizedBox(width: 20),
            // LinkedIn
            _SocialIconButton(
              assetPath: 'assets/icons/linkedin.png',
              url: 'https://linkedin.com',
              tooltip: 'LinkedIn',
              onTap: () => _launchURL('https://linkedin.com'),
            ),
            const SizedBox(width: 20),
            // Twitter
            _SocialIconButton(
              assetPath: 'assets/icons/twitter.png',
              url: 'https://twitter.com',
              tooltip: 'Twitter',
              onTap: () => _launchURL('https://twitter.com'),
            ),
            const SizedBox(width: 20),
            // Facebook
            _SocialIconButton(
              assetPath: 'assets/icons/facebook_logo.png',
              url: 'https://facebook.com',
              tooltip: 'Facebook',
              onTap: () => _launchURL('https://facebook.com'),
            ),
          ],
        ),
        const SizedBox(height: 50),
        // CTA Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Download CV',
                    backgroundColor: DColors.primaryDark,
                    sIcon: const Icon(Icons.download_for_offline_outlined, color: DColors.white),
                    onTap: () {
                      _launchURL('https://yourportfoliosite.com/cv.pdf');
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
                  const SizedBox(width: 10, height: 10),
                  CustomButton(
                    text: 'Contact',
                    backgroundColor: Colors.transparent,
                    width: 240,
                    sIcon: const Icon(Icons.send, color: DColors.primaryDark),
                    textColor: DColors.primaryDark,
                    border: const BorderSide(color: DColors.primaryDark, width: 2),
                    onTap: () {
                      _launchURL('mailto:your.email@example.com?subject=Let\'s Work Together');
                    },
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  final String assetPath;
  final String url;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.assetPath,
    required this.url,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isHovered ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: DColors.primaryDark.withValues(alpha: _isHovered ? 0.25 : 0.1),
                    blurRadius: _isHovered ? 16 : 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.assetPath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

