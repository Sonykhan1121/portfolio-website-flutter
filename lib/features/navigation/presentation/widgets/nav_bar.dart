import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/break_points.dart';
import 'package:portfolio_website_flutter/core/extensions/provider_extension.dart';
import 'package:portfolio_website_flutter/features/navigation/presentation/widgets/logo_widget.dart';

import 'nav_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.navigationController;
    return Container(
      width: Breakpoints.screenMaxWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
        child: Row(
          children: [
            // Logo
            LogoWidget(text: "Dev"),
            const Spacer(),
            // Navigation Items
            Row(
              children: List.generate(
                controller.menuItems.length,
                (index) => NavItem(
                  title: controller.menuItems[index],
                  index: index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
