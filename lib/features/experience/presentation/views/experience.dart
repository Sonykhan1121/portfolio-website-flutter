// ─── experience.dart ──────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../widgets/experience_section.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';
import '../../../../core/constants/sizes.dart';

class Experience extends StatefulWidget {
  const Experience({super.key});

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _ctrl,
          curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _slide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _ctrl,
              curve: const Interval(0, 0.6, curve: Curves.easeOutCubic)),
        );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Column(
              children: [
                NumberWithTitle(number: "04", title: "Experience"),
                const SizedBox(height: 10),
                Text(
                  'My professional journey so far',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.descriptionFontSize * 0.92,
                    color: Colors.black.withValues(alpha: 0.42),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.sectionSpacing * 1.2),
        const ExperienceSection(),
      ],
    );
  }
}