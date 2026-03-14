import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';

import 'mobile_platforms.dart';

class DesktopPlatforms extends StatelessWidget {
  final BuildContext context;
  const DesktopPlatforms({required this.context});

  @override
  Widget build(BuildContext _) {
    final platforms = platformList(context);
    return Column(
      children: [
        Row(children: [
          Expanded(child: platforms[0]),
          SizedBox(width: context.platformSpacing),
          Expanded(child: platforms[1]),
          SizedBox(width: context.platformSpacing),
          Expanded(child: platforms[2]),
        ]),
        SizedBox(height: context.platformSpacing),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.28).clamp(160, 260),
            child: platforms[3],
          ),
          SizedBox(width: context.platformSpacing),
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.28).clamp(160, 260),
            child: platforms[4],
          ),
        ]),
      ],
    );
  }
}

