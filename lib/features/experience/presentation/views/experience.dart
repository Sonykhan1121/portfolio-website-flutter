import 'package:flutter/material.dart';
import '../widgets/experience_section.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';


class Experience extends StatelessWidget {
  const Experience({super.key});

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
