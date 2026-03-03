import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:portfolio_website_flutter/core/extensions/provider_extension.dart';

class NavItem extends StatefulWidget {
  final String title;
  final int index;

  const NavItem({super.key, required this.title, required this.index});

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final controller = context.navigationController;
    final isActive = controller.currentIndex == widget.index;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => controller.selectIndex(widget.index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isActive || _isHovered ? DColors.primaryLight : DColors.primaryDark,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Text(widget.title),
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
      ),
    );
  }
}
