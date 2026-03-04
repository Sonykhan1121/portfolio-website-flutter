import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/extensions/provider_extension.dart';
import 'package:provider/provider.dart';
import '../widgets/sticky_nav_bar.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/break_points.dart';
import '../../../about/presentation/views/about_me.dart';
import '../../../intro/presentation/views/intro_page.dart';
import '../../../get_in_touch/presentation/views/get_in_touch.dart';
import '../../../experience/presentation/views/experience.dart';
import '../../../projects/presentation/views/projects.dart';
import '../../../skills/presentation/views/skills.dart';
import 'package:portfolio_website_flutter/features/navigation/viewmodels/navigation_controller.dart';
import 'package:portfolio_website_flutter/features/navigation/presentation/widgets/mobile_drawer.dart';
import 'package:portfolio_website_flutter/features/navigation/presentation/widgets/mobile_app_bar.dart';

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
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
  }

  void _scrollToSection(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final context = _sectionKeys[index].currentContext;
        if (context != null) {
          Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 800), curve: Curves.easeInOutCubic);
        }
      } catch (e) {
        debugPrint('Scroll error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (BuildContext context, NavigationController nvController, Widget? child) {
        return LayoutBuilder(
          builder: (context, c) {
            final isMobile = c.maxWidth < Breakpoints.mobile;
            double screenWidth = MediaQuery.of(context).size.width;
            double dynamicRadius = screenWidth * 0.15;

            return Scaffold(
              backgroundColor: DColors.white,
              appBar:
                  isMobile
                      ? MobileAppBar()
                      : null,
              endDrawer: isMobile ? MobileDrawer(scrollToTop: _scrollToTop, scrollToSection: _scrollToSection,) : null,
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
                            IntroPage(dynamicRadius: dynamicRadius, isMobile: isMobile),
                            // Section Two - About
                            Container(key: _sectionKeys[1], child: AboutMe()),
                            // Section Three - Skills
                            Container(
                              key: _sectionKeys[2],
                              child: Skills(skills: nvController.skillData),
                            ),
                            // Section Four - Projects
                            Container(
                              key: _sectionKeys[3],
                              child: Projects(projects: nvController.projectData),
                            ),
                            // Section Five
                            Container(key: _sectionKeys[4], child: Experience()),
                            // Section Six - Contact & Footer
                            Container(key: _sectionKeys[5], child: GetInTouch()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Fixed Navigation Bar at Top
                  if (!isMobile)
                    StickyNavBar(nvController: nvController,scrollToSection: _scrollToSection,scrollToTop: _scrollToTop,)
                ],
              ),
            );
          },
        );
      },
    );
  }

}
