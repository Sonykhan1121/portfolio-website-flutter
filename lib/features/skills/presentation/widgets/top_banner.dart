// ─────────────────────────────────────────────────────────────────────────────
// Top gradient banner with icon + title
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

class TopBanner extends StatelessWidget {
  final Color accent1, accent2;
  final String icon, title;
  final Animation<double> hoverT;
  final bool isMobile;

  const TopBanner({
    required this.accent1,
    required this.accent2,
    required this.icon,
    required this.title,
    required this.hoverT,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: hoverT,
      builder: (_, __) => Container(
        height: isMobile ? 100 : 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(accent1.withValues(alpha: 0.12), accent1.withValues(alpha: 0.22), hoverT.value)!,
              Color.lerp(accent2.withValues(alpha: 0.07), accent2.withValues(alpha: 0.15), hoverT.value)!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 22,
          vertical: isMobile ? 18 : 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon box
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: accent1.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                icon,
                height: isMobile ? 26 : 30,
                width: isMobile ? 26 : 30,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 17 : 19,
                      fontWeight: FontWeight.w800,
                      color: accent1.withValues(alpha: 0.85),
                      letterSpacing: 0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Animated underline
                  AnimatedBuilder(
                    animation: hoverT,
                    builder: (_, __) => Container(
                      height: 2.5,
                      width: 28 + 20 * hoverT.value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [accent1, accent2]),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}