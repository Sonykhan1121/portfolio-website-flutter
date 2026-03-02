import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class SkillCard extends StatelessWidget {
  final String icon;
  final String title;

  const SkillCard({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1,color: DColors.primaryLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: DColors.primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),

                ),
                padding: EdgeInsets.all(16),
                child: Image.asset(icon, height: 20, width: 20, fit: BoxFit.contain),
              ),
              SizedBox(width: 20),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
          SizedBox(height: 20,),

        ],
      ),
    );
  }
}
