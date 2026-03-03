import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:portfolio_website_flutter/features/home/presentation/widgets/project_topic.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> listOfTopics;
  final String url;
  final Map<String, dynamic>? projectData;
  final VoidCallback? onTap;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.listOfTopics,
    required this.url,
    this.projectData,
    this.onTap,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: DColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1.5,
              color: _isHovered
                  ? DColors.primaryLight.withValues(alpha: 0.8)
                  : DColors.primaryLight.withValues(alpha: 0.6),
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: DColors.primaryLight.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: DColors.primaryLight.withValues(alpha: 0.08),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? DColors.primaryLight.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isHovered
                                ? DColors.primaryLight.withValues(alpha: 0.3)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          "assets/icons/git_tag.png",
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? DColors.primaryLight.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isHovered
                                ? DColors.primaryLight.withValues(alpha: 0.3)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          "assets/icons/open_url.png",
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              ProjectTopic(topics: widget.listOfTopics),
            ],
          ),
        ),
      ),
    );
  }
}

