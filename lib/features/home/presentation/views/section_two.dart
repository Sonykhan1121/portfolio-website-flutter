import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/shared/custom_button.dart';
import '../widgets/number_with_title.dart';

class SectionTwo extends StatelessWidget {
  const SectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "01", title: "About Me"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 40),

              Text(
                'I am a passionate Flutter Software Developer with a strong foundation in building cross-platform applications. My focus is on creating clean, scalable, and user-centric solutions that deliver exceptional experiences across all platforms.',
              ),
              SizedBox(height: 20),
              Text(
                'With expertise in Dart and the Flutter framework, I specialize in developing applications that run seamlessly on Android, iOS, Web, and Desktop from a single codebase. I value clean architecture, reusable components, and maintainable code.',
              ),
              SizedBox(height: 20),
              Text(
                'I am constantly learning and exploring new technologies to stay at the forefront of cross-platform development, while delivering polished products that users love.',
              ),
              SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text('PLATFORMS I BUILD FOR')]),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      textColor: DColors.black,
                      pIcon: Image.asset(
                        'assets/icons/android_tag.png',
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                      ),
                      border: const BorderSide(color: DColors.primaryColor, width: 1),
                      text: "Android",
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      pIcon: Icon(Icons.phone_android,color: DColors.primaryColor,),
                      border: const BorderSide(color: DColors.primaryColor, width: 1),
                      textColor: DColors.black,
                      text: "IOS",
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      textColor: DColors.black,
                      pIcon: Icon(Icons.account_tree_outlined,color: DColors.primaryColor,),
                      border: const BorderSide(color: DColors.primaryColor, width: 1),
                      text: "Web",
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: CustomButton(
                      backgroundColor: Colors.transparent,
                      pIcon: Icon(Icons.desktop_mac_outlined,color: DColors.primaryColor,),
                      border: const BorderSide(color: DColors.primaryColor, width: 1),
                      textColor: DColors.black,
                      text: "Desktop",
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
