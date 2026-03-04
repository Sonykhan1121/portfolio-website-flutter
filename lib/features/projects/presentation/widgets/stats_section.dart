import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/stat_item.dart';

// Stats Section Widget
class StatsSection extends StatelessWidget {
  final BuildContext context;

  const StatsSection(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.horizontalPadding),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.04),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Stats',
            style: TextStyle(fontSize: context.h4, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          SizedBox(height: context.elementSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(label: 'Status', value: 'Completed', context: context),
              StatItem(label: 'Duration', value: '2-3 months', context: context),
              StatItem(label: 'Team Size', value: '2 persons', context: context),
            ],
          ),
        ],
      ),
    );
  }
}
