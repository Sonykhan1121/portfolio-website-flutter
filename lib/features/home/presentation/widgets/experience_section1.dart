import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
// ── Data model ──────────────────────────────────────────────────────────────

class ExperienceItem {
  const ExperienceItem({
    required this.period,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogo,
    required this.description,
    required this.location
  });

  final String period;
  final String jobTitle;
  final String companyName;
  final String companyLogo;
  final String description;
  final String location;
}

// ── Main section widget ──────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const _items = [
    ExperienceItem(
      period: '2025 — Present',
      jobTitle: 'Flutter Developer',
      companyName: 'Tech Company',
      companyLogo: 'assets/icons/facebook_logo.png',
      description:
      'Developing and maintaining cross-platform applications using Flutter '
          'and Dart. Collaborating with design and backend teams to deliver '
          'high-quality user experiences.',
      location: "dhaka"
    ),
    ExperienceItem(
      period: '2024 — 2025',
      jobTitle: 'Junior Flutter Developer',
      companyName: 'Startup Inc.',
      description:
      'Built mobile applications from scratch, implemented state management '
          'patterns, and integrated third-party APIs. Contributed to code '
          'reviews and technical documentation.',
      location:  "UK",
      companyLogo: "assets/icons/twitter.png"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        children: List.generate(_items.length, (i) {
          final isLast = i == _items.length - 1;
          return _TimelineRow(
            item: _items[i],
            isLast: isLast,
          );
        }),
      ),
    );
  }
}

// ── Single timeline row ──────────────────────────────────────────────────────

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.isLast,
  });

  final ExperienceItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Period label ──
          SizedBox(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                item.period,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: DColors.primaryLight.withOpacity(0.8),
                  fontSize: 16,
                  letterSpacing: 0.2,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // ── Timeline spine ──
          _TimelineSpine(isLast: isLast),

          const SizedBox(width: 20),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title · Company
                  Row(
                    children: [
                      Image.asset(item.companyLogo,height: 25,width: 25,),
                      SizedBox(width: 10,),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: item.jobTitle,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.1,
                              ),
                            ),
                            TextSpan(
                              text: '  ·  ',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: item.companyName,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.65,
                      letterSpacing: 0.1,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.location,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
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

// ── Timeline spine (line + dot) ──────────────────────────────────────────────

class _TimelineSpine extends StatelessWidget {
  const _TimelineSpine({required this.isLast});

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      child: Column(
        children: [
          // Dot
          Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(color: DColors.primaryLight, width: 2),
            ),
            child: Center(
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DColors.primaryLight,
                ),
              ),
            ),
          ),

          // Vertical line
          if (!isLast)
            Expanded(
              child: Container(
                width: 1.5,
                color: DColors.primaryLight.withValues(alpha: 0.25),
              ),
            ),
        ],
      ),
    );
  }
}
