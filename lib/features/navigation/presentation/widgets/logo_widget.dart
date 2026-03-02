import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class LogoWidget extends StatelessWidget {
  final String text;
  const LogoWidget({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '<',
            style: TextStyle(color: DColors.primaryDark),
          ),
          TextSpan(
            text: text,
            style: TextStyle(color: DColors.primaryDark, fontWeight: FontWeight.bold)
          ),
          TextSpan(
            text: '/>',
            style: TextStyle(color: DColors.primaryDark),
          ),
        ],
        style: TextStyle(fontFamily:'monospace',fontSize: 20)
      )
    );
  }
}
