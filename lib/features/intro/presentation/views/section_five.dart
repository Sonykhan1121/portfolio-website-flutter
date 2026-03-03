import 'package:flutter/material.dart';
import '../widgets/experience_section1.dart';
import '../widgets/number_with_title.dart';


class SectionFive extends StatelessWidget {
  const SectionFive({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NumberWithTitle(number: "04", title: "Experience"),
        SizedBox(height: 20,),
        ExperienceSection(),

      ],
    );
  }
}
