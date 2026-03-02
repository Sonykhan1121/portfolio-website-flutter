import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:portfolio_website_flutter/core/extensions/provider_extension.dart';

class NavItem extends StatelessWidget {
  final String title;
  final int index;

  const NavItem({super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = context.navigationController;
    final isActive = controller.currentIndex == index;
    return TextButton(
      onPressed: () => controller.selectIndex(index),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? DColors.primaryLight:DColors.primaryDark,
          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }
}
