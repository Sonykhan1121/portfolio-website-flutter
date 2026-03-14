import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';

class BioParagraph extends StatelessWidget {
  final String text;
  final BuildContext context;
  const BioParagraph({required this.text, required this.context});

  @override
  Widget build(BuildContext _) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: DColors.primaryDark.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: DColors.primaryDark.withValues(alpha: 0.07),
          width: 1,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: context.descriptionFontSize,
          height: 1.85,
          color: Colors.black.withValues(alpha: 0.68),
          letterSpacing: 0.25,
        ),
      ),
    );
  }
}