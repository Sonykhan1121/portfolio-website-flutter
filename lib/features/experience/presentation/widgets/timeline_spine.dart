import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class TimelineSpine extends StatelessWidget {
  const TimelineSpine({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      child: Column(
        children: [
          // Dot
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: DColors.primaryLight, width: 2),
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(shape: BoxShape.circle, color: DColors.primaryLight),
              ),
            ),
          ),

          // Vertical line
          if (!isLast) Expanded(child: Container(width: 1.5, color: DColors.primaryLight.withValues(alpha: 0.25))),
        ],
      ),
    );
  }
}