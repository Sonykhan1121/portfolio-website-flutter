import 'package:flutter/material.dart';
import '../../../../core/constants/sizes.dart';
// Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;
  final BuildContext context;

  const SectionTitle(this.title, this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: Sizes.h4(context),
        fontWeight: FontWeight.w800,
        color: Colors.black,
        letterSpacing: 0.3,
      ),
    );
  }
}