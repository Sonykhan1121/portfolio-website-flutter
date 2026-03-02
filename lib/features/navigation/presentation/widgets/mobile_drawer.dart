import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/navigation/viewmodels/navigation_controller.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (BuildContext context, NavigationController controller, Widget? child) {
        return Drawer(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: controller.menuItems.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(controller.menuItems[index]),
                selected: controller.currentIndex == index,
                selectedColor: DColors.primaryLight,
                onTap: () {
                  controller.selectIndex(index);
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }
}
