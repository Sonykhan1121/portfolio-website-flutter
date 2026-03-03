import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/navigation/presentation/widgets/logo_widget.dart';
import 'package:portfolio_website_flutter/features/navigation/viewmodels/navigation_controller.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';

class MobileDrawer extends StatelessWidget {
  final  Function() scrollToTop;
  final  Function(int) scrollToSection;
  const MobileDrawer({super.key,required this.scrollToTop,required this.scrollToSection});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (BuildContext context, NavigationController controller, Widget? child) {
        return Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header with Logo
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(onTap:(){
                      scrollToTop();
                      Navigator.pop(context);
                    } ,child: LogoWidget(text: "Dev"),),
                    IconButton(
                      icon: const Icon(Icons.close, color: DColors.primaryDark),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black.withValues(alpha: 0.1),
                thickness: 1,
              ),
              // Navigation Items
              ...List.generate(
                controller.menuItems.length,
                (index) {
                  final isSelected = controller.currentIndex == index;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? DColors.primaryLight.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(
                        controller.menuItems[index],
                        style: TextStyle(
                          color: isSelected ? DColors.primaryLight : DColors.primaryDark,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                      leading: isSelected
                          ? Container(
                              width: 4,
                              height: 24,
                              decoration: BoxDecoration(
                                color: DColors.primaryLight,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            )
                          : null,
                      onTap: () {
                        scrollToSection(index + 1);
                        controller.selectIndex(index);
                        Navigator.pop(context);
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      hoverColor: Colors.black.withValues(alpha: 0.05),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Divider(
                color: Colors.black.withValues(alpha: 0.1),
                thickness: 1,
              ),
              // Footer text
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '© 2026 Sidratul Montaha\nBuilding the future, one widget at a time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.5),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
