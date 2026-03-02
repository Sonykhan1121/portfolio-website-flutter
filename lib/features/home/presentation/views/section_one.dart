import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/shared/custom_button.dart';
import '../widgets/action_status.dart';

class SectionOne extends StatelessWidget {
  final dynamic dynamicRadius;
  final bool isMobile ;
  const SectionOne({super.key,required this.dynamicRadius,required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40),
        CircleAvatar(
          radius: dynamicRadius.clamp(50.0, 100.0),
          backgroundImage: AssetImage('assets/images/profilepic.png'),
        ),
        SizedBox(height: 10),
        ActionStatus(title: 'Available for opportunities'),
        SizedBox(height: 40),
        Text('Sidratul Montaha', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
        SizedBox(height: 20),
        Text(
          'Flutter Software Developer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: DColors.primaryLight),
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: "I build beautiful, performant cross-platform applications for"),
                TextSpan(text: "Android", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", "),
                TextSpan(text: "IOS", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", "),
                TextSpan(text: "Web", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", "),
                TextSpan(text: "Desktop", style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "."),
                TextSpan(
                  text:
                  "Turning ideas into polished digital experiences with clean code and thoughtful design.",
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Download CV',
                    backgroundColor: DColors.primaryDark,
                    sIcon: Icon(Icons.download_for_offline_outlined, color: DColors.white),
                    onTap: () => print('Hired!'),
                    width: 240,
                    shadows: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10, height: 10),
                  CustomButton(
                    text: 'Contact',
                    backgroundColor: Colors.transparent,
                    width: 240,
                    sIcon: Icon(Icons.send, color: DColors.primaryDark),
                    textColor: DColors.primaryDark,
                    border: const BorderSide(color: DColors.primaryDark, width: 2),
                    onTap: () {},
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
