// ─── projects.dart ────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../widgets/projects_section.dart';
import '../../../intro/presentation/widgets/number_with_title.dart';
import '../../../../core/constants/sizes.dart';

class Projects extends StatefulWidget {
  final List<Map<String, dynamic>> projects;
  const Projects({super.key, required this.projects});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOut)),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOutCubic)),
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
                NumberWithTitle(number: "03", title: "Featured Projects"),
                const SizedBox(height: 10),
                Text(
                  'Things I\'ve built that I\'m proud of',
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
        ProjectsSection(projects: widget.projects),
      ],
    );
  }
}