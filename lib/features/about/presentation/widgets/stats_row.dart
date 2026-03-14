import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/features/about/presentation/widgets/stat_card.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/stat_data.dart';

class StatsRow extends StatelessWidget {
  final List<StatData> stats;
  final List<int> animated;
  const StatsRow({required this.stats, required this.animated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DColors.primaryDark.withValues(alpha: 0.04),
            DColors.primaryDark.withValues(alpha: 0.09),
            DColors.primaryDark.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: DColors.primaryDark.withValues(alpha: 0.10),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.asMap().entries.map((e) {
          final isLast = e.key == stats.length - 1;
          return Row(
            children: [
              StatCard(data: e.value, animatedValue: animated[e.key]),
              if (!isLast)
                Container(
                  width: 1,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: DColors.primaryDark.withValues(alpha: 0.12),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}