import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';
import 'package:portfolio_website_flutter/core/constants/colors.dart';
import 'package:portfolio_website_flutter/core/shared/custom_button.dart';
import 'package:portfolio_website_flutter/features/intro/data/services/url_launcher_service.dart';

import 'footer_social_icon.dart';


class GetInTouch extends StatefulWidget {
  const GetInTouch({super.key});

  @override
  State<GetInTouch> createState() => _GetInTouchState();
}

class _GetInTouchState extends State<GetInTouch> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();


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
                  FooterSocialIcon(
                    assetPath: 'assets/icons/git_tag.png',
                    tooltip: 'GitHub',
                    onTap: () => UrlLauncherService.launchExternal('https://github.com/sonykhan1121'),
                  ),
                  const SizedBox(width: 15),
                  FooterSocialIcon(
                    assetPath: 'assets/icons/linkedin.png',
                    tooltip: 'LinkedIn',
                    onTap: () => UrlLauncherService.launchExternal('https://linkedin.com'),
                  ),
                  const SizedBox(width: 15),
                  FooterSocialIcon(
                    assetPath: 'assets/icons/twitter.png',
                    tooltip: 'Twitter',
                    onTap: () => UrlLauncherService.launchExternal('https://twitter.com'),
                  ),
                  const SizedBox(width: 15),
                  FooterSocialIcon(
                    assetPath: 'assets/icons/facebook_logo.png',
                    tooltip: 'Facebook',
                    onTap: () => UrlLauncherService.launchExternal('https://facebook.com'),
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




