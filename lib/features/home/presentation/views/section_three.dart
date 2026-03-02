import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/home/presentation/widgets/number_with_title.dart';
import 'package:portfolio_website_flutter/features/home/presentation/widgets/skill_card.dart';

class SectionThree extends StatelessWidget {
  const SectionThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "02", title: "Skills"),
        SizedBox(height: 40),
        SkillCard(icon: "assets/icons/html_tag.png", title: "Flutter & Dart"),
      ],
    );
  }
}
