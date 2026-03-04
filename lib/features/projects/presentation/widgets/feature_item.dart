import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';
// Feature Item Widget
class FeatureItem extends StatelessWidget {
  final String label;
  final BuildContext context;

  const FeatureItem({super.key, required this.label, required this.context});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.elementSpacing * 0.6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 16,
              color: Colors.green.shade600,
            ),
          ),
          SizedBox(width: context.elementSpacing * 0.6),
          Text(
            label,
            style: TextStyle(
              fontSize: context.body,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}