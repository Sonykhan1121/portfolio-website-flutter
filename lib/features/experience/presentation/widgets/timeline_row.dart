import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/experience_model.dart';
import 'package:portfolio_website_flutter/features/experience/presentation/widgets/timeline_spine.dart';
import '../../../../core/constants/sizes.dart';

class TimelineRow extends StatelessWidget {
  const TimelineRow({super.key, required this.item, required this.isLast});

  final ExperienceItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    // Responsive widths & spacings
    final periodWidth = isMobile ? 100.0 : isTablet ? 120.0 : 140.0;
    final spacerSmall = context.platformSpacing; // 12 / 16 / 20
    final spacerMedium = context.elementSpacing * 0.8; // ~16 / 19 / 25

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Period label ──
          SizedBox(
            width: periodWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item.period,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: DColors.primaryLight.withValues(alpha: 0.8),
                  fontSize: context.body, // responsive (14/16)
                  letterSpacing: 0.2,
                  height: 1.5,
                ),
              ),
            ),
          ),

          SizedBox(width: spacerSmall),

          // ── Timeline spine ──
          TimelineSpine(isLast: isLast),

          SizedBox(width: spacerSmall),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: context.sectionSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title · Company
                  Row(
                    children: [
                      Image.asset(item.companyLogo, height: context.h4, width: context.h4),
                      SizedBox(width: spacerMedium * 0.6),
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: item.jobTitle,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: context.h3,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.1,
                                ),
                              ),
                              TextSpan(
                                text: '  ·  ',
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  fontSize: context.h3,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: item.companyName,
                                style: TextStyle(
                                  color: Colors.black.withValues(alpha: 0.8),
                                  fontSize: context.h3,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: context.elementSpacing * 0.5),

                  // Description
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.8),
                      fontSize: context.descriptionFontSize,
                      height: 1.65,
                      letterSpacing: 0.1,
                    ),
                  ),

                  SizedBox(height: context.elementSpacing * 0.4),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: context.caption * 1.1, color: Colors.black.withValues(alpha: 0.6)),
                      SizedBox(width: context.elementSpacing * 0.25),
                      Text(
                        item.location,
                        style: TextStyle(
                          color: Colors.black.withValues(alpha: 0.6),
                          fontSize: context.small,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}