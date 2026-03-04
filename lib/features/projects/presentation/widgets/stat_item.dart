import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';
// Stat Item Widget
class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final BuildContext context;

  const StatItem({super.key,
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: context.caption,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.6),
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: context.elementSpacing * 0.2),
        Text(
          value,
          style: TextStyle(
            fontSize: context.body,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}