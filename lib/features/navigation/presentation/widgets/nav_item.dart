import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';

class NavItem extends StatelessWidget {
  final String title;
  final int index;
  final bool isActive;
  final Function() onTap;
  const NavItem({super.key,required this.title,required this.index,required this.onTap,required this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isActive ? DColors.primaryLight : DColors.primaryDark,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontSize: context.platformLabelFontSize,
              letterSpacing: 0.5,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.elementSpacing * 0.9,
                vertical: context.elementSpacing * 0.4,
              ),
              child: Text(title),
            ),
          ),
          // Animated underline
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: isActive ? 30 : 0,
            decoration: BoxDecoration(color: DColors.primaryLight, borderRadius: BorderRadius.circular(1)),
          ),
        ],
      ),
    );
  }

}
