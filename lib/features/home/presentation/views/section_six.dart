import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:portfolio_website_flutter/core/constants/colors.dart';
import 'package:portfolio_website_flutter/core/shared/custom_button.dart';
import 'package:portfolio_website_flutter/features/home/presentation/widgets/experience_section1.dart';
import 'package:portfolio_website_flutter/features/home/presentation/widgets/number_with_title.dart';

class SectionSix extends StatefulWidget {
  const SectionSix({super.key});

  @override
  State<SectionSix> createState() => _SectionSixState();
}

class _SectionSixState extends State<SectionSix> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final message = _messageController.text;

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final emailUrl = Uri.parse(
      'mailto:your.email@example.com?subject=Contact from $name&body=$message\n\nFrom: $email',
    );

    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email opened in your default client')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberWithTitle(number: "05", title: "Get In Touch"),
              const SizedBox(height: 30),
              // Description
              Text(
                'I\'m always open to discussing new projects, creative ideas, or opportunities to be part of something great. Feel free to reach out and let\'s build something amazing together.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withValues(alpha: 0.7),
                  height: 1.6,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 50),
              // // Social Icons Label
              // Text(
              //   'FIND ME ONLINE',
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.w600,
              //     letterSpacing: 1.5,
              //     color: Colors.black.withValues(alpha: 0.7),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // // All Social Icons - Clickable
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     _SocialIconButton(
              //       assetPath: 'assets/icons/git_tag.png',
              //       tooltip: 'GitHub',
              //       onTap: () => _launchURL('https://github.com'),
              //     ),
              //     const SizedBox(width: 20),
              //     _SocialIconButton(
              //       assetPath: 'assets/icons/linkedin.png',
              //       tooltip: 'LinkedIn',
              //       onTap: () => _launchURL('https://linkedin.com'),
              //     ),
              //     const SizedBox(width: 20),
              //     _SocialIconButton(
              //       assetPath: 'assets/icons/twitter.png',
              //       tooltip: 'Twitter',
              //       onTap: () => _launchURL('https://twitter.com'),
              //     ),
              //     const SizedBox(width: 20),
              //     _SocialIconButton(
              //       assetPath: 'assets/icons/facebook_logo.png',
              //       tooltip: 'Facebook',
              //       onTap: () => _launchURL('https://facebook.com'),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 60),
              // Contact Form
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Field
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: DColors.primaryDark.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'your.email@example.com',
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: DColors.primaryDark.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Message Field
                  Text(
                    'Message',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Your message here...',
                      hintStyle: TextStyle(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: DColors.primaryDark.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Send Button
                  Center(
                    child: CustomButton(
                      text: 'Send Message',
                      onTap: _sendEmail,
                      backgroundColor: DColors.primaryDark,
                      textColor: Colors.white,
                      height: 50,
                      borderRadius: 8,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      width: 240,
                      sIcon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      shadows: [
                        BoxShadow(
                          color: DColors.primaryDark.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              // Divider
              Divider(
                color: Colors.black.withValues(alpha: 0.1),
                thickness: 1,
              ),
              const SizedBox(height: 40),
              // Footer Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '© 2026 Sang Zi Jin. Crafted with care',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Building the future, one widget at a time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Footer Social Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FooterSocialIcon(
                    assetPath: 'assets/icons/git_tag.png',
                    tooltip: 'GitHub',
                    onTap: () => _launchURL('https://github.com'),
                  ),
                  const SizedBox(width: 15),
                  _FooterSocialIcon(
                    assetPath: 'assets/icons/linkedin.png',
                    tooltip: 'LinkedIn',
                    onTap: () => _launchURL('https://linkedin.com'),
                  ),
                  const SizedBox(width: 15),
                  _FooterSocialIcon(
                    assetPath: 'assets/icons/twitter.png',
                    tooltip: 'Twitter',
                    onTap: () => _launchURL('https://twitter.com'),
                  ),
                  const SizedBox(width: 15),
                  _FooterSocialIcon(
                    assetPath: 'assets/icons/facebook_logo.png',
                    tooltip: 'Facebook',
                    onTap: () => _launchURL('https://facebook.com'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}

// Social Icon Widget for Main Section
class _SocialIconButton extends StatefulWidget {
  final String assetPath;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.assetPath,
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
            scale: _isHovered ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: DColors.primaryDark.withValues(
                      alpha: _isHovered ? 0.2 : 0.1,
                    ),
                    blurRadius: _isHovered ? 12 : 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.assetPath,
                  width: 45,
                  height: 45,
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

// Footer Social Icon Widget
class _FooterSocialIcon extends StatefulWidget {
  final String assetPath;
  final String tooltip;
  final VoidCallback onTap;

  const _FooterSocialIcon({
    required this.assetPath,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_FooterSocialIcon> createState() => _FooterSocialIconState();
}

class _FooterSocialIconState extends State<_FooterSocialIcon> {
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
            scale: _isHovered ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: DColors.primaryDark.withValues(
                      alpha: _isHovered ? 0.2 : 0.1,
                    ),
                    blurRadius: _isHovered ? 10 : 5,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.assetPath,
                  width: 32,
                  height: 32,
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

