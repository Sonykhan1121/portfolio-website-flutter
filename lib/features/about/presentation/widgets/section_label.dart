// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';

import '../../../../core/constants/colors.dart';

class SectionLabel extends StatelessWidget {
  final String label;
  final BuildContext context;
  const SectionLabel({required this.label, required this.context});

  @override
  Widget build(BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 1.5,
          color: DColors.primaryDark.withValues(alpha: 0.3),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: context.sectionTitleFontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: DColors.primaryDark.withValues(alpha: 0.65),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 28,
          height: 1.5,
          color: DColors.primaryDark.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}