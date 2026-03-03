import 'nav_item.dart';
import 'logo_widget.dart';
import 'package:flutter/material.dart';
import '../../viewmodels/navigation_controller.dart';
import '../../../../core/constants/break_points.dart';

class StickyNavBar extends StatelessWidget {
  final NavigationController nvController;
  final void Function() scrollToTop;
  final void Function(int) scrollToSection;

  const StickyNavBar({super.key, required this.nvController, required this.scrollToTop, required this.scrollToSection});

  @override
  Widget build(BuildContext context) {
    return Positioned(top: 0, left: 0, right: 0, child: _buildStickyNavBar(context, nvController));
  }

  Widget _buildStickyNavBar(BuildContext context, NavigationController nvController) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4))],
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
                  onTap: scrollToTop,
                  child: MouseRegion(cursor: SystemMouseCursors.click, child: LogoWidget(text: "Dev")),
                ),
                const Spacer(),
                // Navigation Items
                Row(
                  children: List.generate(
                    nvController.menuItems.length,
                    (index) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: NavItem(
                        title: nvController.menuItems[index],
                        index: index,
                        isActive: nvController.currentIndex == index,
                        onTap: () {
                          nvController.selectIndex(index);
                          scrollToSection(index + 1);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
