import 'logo_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MobileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DColors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      title: LogoWidget(text: 'Dev'),
      centerTitle: true,
      iconTheme: const IconThemeData(color: DColors.primaryDark),
    );
  }

  @override

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
