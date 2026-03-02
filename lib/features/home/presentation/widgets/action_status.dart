import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class ActionStatus extends StatelessWidget {
  final String title;

  const ActionStatus({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: DColors.grey300, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 5, backgroundColor: DColors.primaryLight),
          SizedBox(width: 5),
          Flexible(child: Text(title, style: TextStyle(color: DColors.grey600))),
        ],
      ),
    );
  }
}
