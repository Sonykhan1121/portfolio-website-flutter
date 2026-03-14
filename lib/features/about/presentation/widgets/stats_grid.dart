import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/about/presentation/widgets/stat_card.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/stat_data.dart';

class StatsGrid extends StatelessWidget {
  final List<StatData> stats;
  final List<int> animated;
  const StatsGrid({required this.stats, required this.animated});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          color: DColors.primaryDark.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: DColors.primaryDark.withValues(alpha: 0.09),
            width: 1,
          ),
        ),
        child: StatCard(data: stats[i], animatedValue: animated[i]),
      ),
    );
  }
}