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
    return SizedBox(
      width: Breakpoints.screenMaxWidth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Row(
          children: [
            LogoWidget(text: "Dev"),
            Spacer(),
            Row(
              children:List.generate(
                controller.menuItems.length,
                    (index) => NavItem(title: controller.menuItems[index], index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
