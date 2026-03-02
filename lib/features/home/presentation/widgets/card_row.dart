import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class CardRow extends StatelessWidget {
  final String text;
  const CardRow({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: DColors.primaryLight),
        SizedBox(width: 10,),
        Text(text),
      ],
    );
  }
}
