import 'package:portfolio_website_flutter/features/home/presentation/views/section_five.dart';
import 'package:portfolio_website_flutter/features/home/presentation/views/section_four.dart';

import '../../../home/presentation/views/section_six.dart';
import '../widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/break_points.dart';
import '../../../home/presentation/views/section_three.dart';
import 'package:portfolio_website_flutter/features/home/presentation/views/section_one.dart';
import 'package:portfolio_website_flutter/features/home/presentation/views/section_two.dart';
import 'package:portfolio_website_flutter/features/navigation/presentation/widgets/mobile_drawer.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_website_flutter/features/navigation/viewmodels/navigation_controller.dart';

class ResponsiveNavBar extends StatefulWidget {
  const ResponsiveNavBar({super.key});

  @override
  State<ResponsiveNavBar> createState() => _ResponsiveNavBarState();
}

class _ResponsiveNavBarState extends State<ResponsiveNavBar> {
  late ScrollController _scrollController;
  final List<GlobalKey> _sectionKeys = [
    GlobalKey(), // Section One
    GlobalKey(), // Section Two
    GlobalKey(), // Section Three
    GlobalKey(), // Section Four
    GlobalKey(), // Section Five
    GlobalKey(), // Section Six
  ];

  final List<Map<String, dynamic>> skillData = [
    {
      "title": "Flutter & Dart",
      "icon": "assets/icons/html_tag.png",
      "listOfSubTitle": ["Flutter Framework", "Dart Language", "Custom Widgets", "Animations", "Responsive UI"],
    },
    {
      "title": "State Management",
      "icon": "assets/icons/state_management_tag.png",
      "listOfSubTitle": ["Provider", "Riverpod", "BLoC Pattern", "GetX", "State Notifier"],
    },
    {
      "title": "Local Databases",
      "icon": "assets/icons/database_tag.png",
      "listOfSubTitle": ["SQLite", "Isar", "Hive", "SharedPreferences", "Secure Storage"],
    },
    {
      "title": "API Integration",
      "icon": "assets/icons/api_tag.png",
      "listOfSubTitle": ["REST APIs", "Dio", "HTTP Package", "JSON Serialization", "WebSockets"],
    },
    {
      "title": "Git & CI/CD",
      "icon": "assets/icons/git_tag.png",
      "listOfSubTitle": ["Git", "GitHub", "GitHub Actions", "Codemagic", "Fastlane"],
    },
  ];

  final List<Map<String, dynamic>> projectData = [
    {
      "title": "E-Commerce App",
      "description":
          "A full-featured e-commerce application with product browsing, cart management, payment integration, and order tracking built with Flutter.",
      "listOfTopics": ["Flutter", "Dart", "REST API", "Provider", "Stripe"],
      "url": "https://github.com/yourusername/ecommerce-app",
    },
    {
      "title": "Task Manager Pro",
      "description":
          "A productivity application with task management, reminders, categories, and analytics. Features offline-first architecture with local database sync.",
      "listOfTopics": ["Flutter", "Riverpod", "Isar", "Notifications"],
      "url": "https://github.com/yourusername/task-manager",
    },
    {
      "title": "Weather Dashboard",
      "description":
          "A beautifully designed weather app displaying real-time data, forecasts, and location-based suggestions with smooth animations and transitions.",
      "listOfTopics": ["Flutter", "Dart", "OpenWeather API", "BLoC"],
      "url": "https://github.com/yourusername/weather-app",
    },
    {
      "title": "Chat Application",
      "description":
          "A real-time messaging application with user authentication, group chats, media sharing, and push notifications across platforms.",
      "listOfTopics": ["Flutter", "Firebase", "WebSockets", "Provider"],
      "url": "https://github.com/yourusername/chat-app",
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToSection(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final context = _sectionKeys[index].currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOutCubic,
          );
        }
      } catch (e) {
        debugPrint('Scroll error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isMobile = c.maxWidth < Breakpoints.mobile;
        double screenWidth = MediaQuery.of(context).size.width;
        double dynamicRadius = screenWidth * 0.15;

        return Scaffold(
          backgroundColor: DColors.white,
          appBar:
              isMobile
                  ? AppBar(
                      backgroundColor: DColors.white,
                      elevation: 2,
                      shadowColor: Colors.black.withValues(alpha: 0.1),
                      title: LogoWidget(text: 'Dev'),
                      centerTitle: true,
                      iconTheme: const IconThemeData(color: DColors.primaryDark),
                    )
                  : null,
          endDrawer: isMobile ? const MobileDrawer() : null,
          body: Stack(
            children: [
              // Main Content with Scroll
              SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: SizedBox(
                    width: Breakpoints.screenMaxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Add top padding to account for fixed navbar
                        if (!isMobile) const SizedBox(height: 100),
                        // Section One - Hero/Landing
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: SectionOne(
                            dynamicRadius: dynamicRadius,
                            isMobile: isMobile,
                          ),
                        ),
                        // Section Two - About
                        Container(
                          key: _sectionKeys[1],
                          child: SectionTwo(),
                        ),
                        // Section Three - Skills
                        Container(
                          key: _sectionKeys[2],
                          child: SectionThree(isMobile: isMobile, skills: skillData),
                        ),
                        // Section Four - Projects
                        Container(
                          key: _sectionKeys[3],
                          child: SectionFour(isMobile: isMobile, projects: projectData),
                        ),
                        // Section Five
                        Container(
                          key: _sectionKeys[4],
                          child: SectionFive(),
                        ),
                        // Section Six - Contact & Footer
                        Container(
                          key: _sectionKeys[5],
                          child: SectionSix(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Fixed Navigation Bar at Top
              if (!isMobile)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildStickyNavBar(context),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickyNavBar(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, controller, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              width: Breakpoints.screenMaxWidth,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                child: Row(
                  children: [
                    // Logo with click to scroll to top
                    GestureDetector(
                      onTap: _scrollToTop,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: LogoWidget(text: "Dev"),
                      ),
                    ),
                    const Spacer(),
                    // Navigation Items
                    Row(
                      children: List.generate(
                        controller.menuItems.length,
                        (index) => _buildNavItem(
                          title: controller.menuItems[index],
                          index: index,
                          isActive: controller.currentIndex == index,
                          onTap: () {
                            controller.selectIndex(index);
                            _scrollToSection(index + 1);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required String title,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isActive ? DColors.primaryLight : DColors.primaryDark,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Text(title),
            ),
          ),
          // Animated underline
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: isActive ? 30 : 0,
            decoration: BoxDecoration(
              color: DColors.primaryLight,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}
