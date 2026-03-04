import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:portfolio_website_flutter/core/constants/sizes.dart';
import 'package:portfolio_website_flutter/features/intro/data/services/url_launcher_service.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/section_title.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/stats_section.dart';
import 'package:portfolio_website_flutter/features/projects/presentation/widgets/technology_tag.dart';

import '../../../../core/constants/colors.dart';
import 'action_button.dart';
import 'feature_item.dart';

// Project Detail Page
class ProjectDetailPage extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailPage({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          project['title'] ?? 'Project',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: context.platformLabelFontSize,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Photo
            Container(
              width: double.infinity,
              height: context.isMobile ? 240 : 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade500,
                    Colors.blue.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (project['projectImagePreview'] != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 1️⃣ Blurred image fills the background — colors auto-match
                          ImageFiltered(
                            imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: Image.network(
                              project['projectImagePreview'] as String,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),

                          // 2️⃣ Subtle dark scrim so the real image pops
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.25),
                                  Colors.black.withValues(alpha: 0.10),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          // 3️⃣ Actual image, contained and centered
                          (project['projectImagePreview'] == null || (project['projectImagePreview'] as String).isEmpty)
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.code_rounded,
                                size: 32,
                                color: Colors.red.withValues(alpha: 0.6),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  project['title'] as String? ?? '',
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Image.network(
                            project['projectImagePreview'] as String,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.code_rounded,
                                  size: 32,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    project['title'] as String? ?? '',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            DColors.primaryLight.withValues(alpha: 0.5),
                            DColors.primaryLight.withValues(alpha: 0.7),
                            DColors.primaryLight,

                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.code_rounded,
                            size: 32,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              project['title'] as String? ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ),
                        ],
                      ) ,
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
                vertical: context.elementSpacing * 1.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Section
                  SectionTitle('About This Project', context),
                  SizedBox(height: context.elementSpacing * 0.6),
                  Text(
                    project['description'] ?? '',
                    style: TextStyle(
                      fontSize: context.descriptionFontSize,
                      height: 1.8,
                      color: Colors.black.withValues(alpha: 0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: context.sectionSpacing),

                  // Technologies Section
                  SectionTitle('Technologies Used', context),
                  SizedBox(height: context.elementSpacing * 0.6),
                  Wrap(
                    spacing: context.elementSpacing * 0.6,
                    runSpacing: context.elementSpacing * 0.6,
                    children: [
                      ...(project['listOfTopics'] as List<String>? ?? [])
                          .map(
                            (topic) => TechnologyTag(label: topic, context: context),
                      ),
                    ],
                  ),
                  SizedBox(height: context.sectionSpacing),

                  // Features Section
                  SectionTitle('Key Features', context),
                  SizedBox(height: context.elementSpacing * 0.6),
                  ...([
                    'Responsive Design',
                    'User-Friendly Interface',
                    'Performance Optimized',
                    'Cross-Platform Compatible',
                  ])
                      .map(
                        (feature) => FeatureItem(label: feature, context: context),
                  ),
                  SizedBox(height: context.sectionSpacing),

                  // Video Demo Section
                  SectionTitle('Video Demo', context),
                  SizedBox(height: context.elementSpacing * 0.6),
                  Container(
                    width: double.infinity,
                    height: context.isMobile ? 200 : 220,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade900,
                                Colors.grey.shade700,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Video player would open here'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.play_arrow,
                                size: 48,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.videocam,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Demo Video',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.sectionSpacing),

                  // Links Section
                  SectionTitle('Project Links', context),
                  SizedBox(height: context.elementSpacing * 0.6),
                  context.isMobile
                      ? Column(
                    children: [
                      ActionButton(
                        icon: Icons.language,
                        label: 'View Live',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Coming soon...'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        isPrimary: true,
                        context: context,
                      ),
                      SizedBox(height: context.elementSpacing * 0.6),
                      ActionButton(
                        icon: Icons.code,
                        label: 'GitHub',
                        onTap: () {
                          UrlLauncherService.launchExternal(
                              project['url'] as String? ?? '');
                        },
                        isPrimary: false,
                        context: context,
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          icon: Icons.language,
                          label: 'View Live',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Coming soon...'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          isPrimary: true,
                          context: context,
                        ),
                      ),
                      SizedBox(width: context.elementSpacing * 0.6),
                      Expanded(
                        child: ActionButton(
                          icon: Icons.code,
                          label: 'GitHub',
                          onTap: () {
                            UrlLauncherService.launchExternal(
                                project['url'] as String? ?? '');
                          },
                          isPrimary: false,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.sectionSpacing),
                  // Statistics Section
                  StatsSection(context),
                  SizedBox(height: context.verticalPadding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


