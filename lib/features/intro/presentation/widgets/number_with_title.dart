import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class NumberWithTitle extends StatelessWidget {
  final String number;
  final String title;
  const NumberWithTitle({super.key,required this.number,required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$number.',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color:DColors.primaryDark)),
          SizedBox(width: 10),
          Text(title,style: TextStyle(fontSize: 26,fontWeight: FontWeight.w900),),
          SizedBox(width: 10),
          // This expands the line to fill remaining space
          Expanded(
            child: Container(
              height: 1,
              color: DColors.black.withValues(alpha: 0.2),
            ),
          ),

        ],
      ),
    );
  }
}
