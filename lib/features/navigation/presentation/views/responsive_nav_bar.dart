import 'package:portfolio_website_flutter/features/home/presentation/views/section_one.dart';
import 'package:portfolio_website_flutter/features/home/presentation/views/section_two.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/shared/custom_button.dart';
import '../../../home/presentation/views/section_three.dart';
import '../../../home/presentation/widgets/number_with_title.dart';
import '../widgets/nav_bar.dart';
import '../widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/break_points.dart';
import '../../../home/presentation/widgets/action_status.dart';
import 'package:portfolio_website_flutter/features/navigation/presentation/widgets/mobile_drawer.dart';

class ResponsiveNavBar extends StatelessWidget {
  const ResponsiveNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isMobile = c.maxWidth < Breakpoints.mobile;
        double screenWidth = MediaQuery.of(context).size.width;
        double dynamicRadius = screenWidth * 0.15;

        return Scaffold(
          appBar: isMobile ? AppBar(backgroundColor:DColors.white,title: LogoWidget(text: 'Dev'), centerTitle: true) : null,
          endDrawer: isMobile ? MobileDrawer() : null,
          body: Container(
            decoration: BoxDecoration(
              color: DColors.white
            ),
            child: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  width: Breakpoints.screenMaxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isMobile) NavBar(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child:SectionOne(dynamicRadius: dynamicRadius,isMobile:isMobile),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child:SectionTwo(),
                      ),
                      SizedBox(
                        height:  MediaQuery.of(context).size.height,
                        child: SectionThree(),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
