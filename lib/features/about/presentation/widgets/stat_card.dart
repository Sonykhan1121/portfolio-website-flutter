import 'package:flutter/material.dart';
import '../../data/models/stat_data.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/colors.dart';

class StatCard extends StatelessWidget {
  final StatData data;
  final int animatedValue;
  const StatCard({required this.data, required this.animatedValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: Sizes.h2(context),
              fontWeight: FontWeight.w900,
              color: DColors.primaryDark,
              letterSpacing: -0.5,
            ),
            children: [
              TextSpan(text: '$animatedValue'),
              TextSpan(
                text: data.suffix,
                style: TextStyle(
                  fontSize: Sizes.h3(context),
                  color: DColors.primaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.competencyFontSize * 0.9,
            fontWeight: FontWeight.w500,
            color: Colors.black.withValues(alpha: 0.45),
            height: 1.4,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}