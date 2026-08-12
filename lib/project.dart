import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.12,
          vertical: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PROJECTS',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = screenWidth >= 1200
                    ? 3
                    : screenWidth >= 800
                    ? 2
                    : 1;
                const gap = 12.0;
                final itemWidth =
                    (constraints.maxWidth - (crossAxisCount - 1) * gap) /
                    crossAxisCount;

                final targetHeight = screenWidth >= 1200
                    ? 360.0
                    : screenWidth >= 800
                    ? 380.0
                    : 400.0;

                final aspectRatio = itemWidth / targetHeight;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: gap,
                    mainAxisSpacing: gap,
                    childAspectRatio: aspectRatio,
                  ),
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    return _ProjectCard(project: _projects[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;

  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovering = false;

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid URL')));
      return;
    }
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error opening link')));
    }
  }

  void _showProjectDetails(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.8),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        final w = MediaQuery.of(context).size.width;
        final isMobile = w < 600;

        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: isMobile ? w * 0.9 : 600,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF6B35).withOpacity(0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.title,
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Color(0xFF333333), height: 1),
                  // Scrollable Content
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About this project',
                            style: GoogleFonts.jetBrainsMono(
                              color: const Color(0xFFFF6B35),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.project.description,
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.grey[300],
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Technologies',
                            style: GoogleFonts.jetBrainsMono(
                              color: const Color(0xFFFF6B35),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.project.technologies.map((tech) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFF6B35,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFFF6B35,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  tech,
                                  style: GoogleFonts.jetBrainsMono(
                                    color: const Color(0xFFFF6B35),
                                    fontSize: 13,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFF333333), height: 1),
                  // Footer Links
                  if (widget.project.links.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: widget.project.links.map((link) {
                          return _LinkButton(
                            text: link.name,
                            onTap: () => _openUrl(link.url),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () => _showProjectDetails(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_isHovering ? 1.0 : 1.0),
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border.all(
                color: _isHovering
                    ? const Color(0xFFFF6B35)
                    : Colors.grey[700]!,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.project.title,
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.project.status != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6B35).withOpacity(0.2),
                          border: Border.all(
                            color: const Color(0xFFFF6B35),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.project.status!,
                          style: GoogleFonts.jetBrainsMono(
                            color: const Color(0xFFFF6B35),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    widget.project.description,
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.grey[300],
                      fontSize: 13,
                      height: 1.45,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  height: 80,
                  child: ScrollConfiguration(
                    behavior: const _NoGlowBehavior(),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.project.technologies
                            .map(
                              (tech) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.grey[600]!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tech,
                                  style: GoogleFonts.jetBrainsMono(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
                if (widget.project.links.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: widget.project.links
                        .map(
                          (link) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _LinkButton(
                              text: link.name,
                              onTap: () => _openUrl(link.url),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}

class _LinkButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _LinkButton({required this.text, required this.onTap});

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isHovering ? const Color(0xFFFF6B35) : Colors.white,
                width: 1,
              ),
            ),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.jetBrainsMono(
              color: _isHovering ? const Color(0xFFFF6B35) : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectModel {
  final String title;
  final String description;
  final List<String> technologies;
  final List<ProjectLink> links;
  final String? status;

  ProjectModel({
    required this.title,
    required this.description,
    required this.technologies,
    required this.links,
    this.status,
  });
}

class ProjectLink {
  final String name;
  final String url;

  ProjectLink({required this.name, required this.url});
}

final List<ProjectModel> _projects = [
  ProjectModel(
    title: 'PlugLess',
    description:
        'PlugLess is a scalable Discord-like social platform built with Flutter and Spring Boot, featuring a global real-time chat, direct messaging, friend requests, user blocking, and automated word filtering. Designed with scalable backend architecture using WebSockets, Redis, message queuing, rate limiting, and asynchronous processing to efficiently handle high-volume real-time communication.',
    technologies: [
      'Flutter',
      'Dart',
      'Spring Boot',
      'WebSockets',
      'Redis',
      'Message Queuing',
      'Rate Limiting',
      'PostgreSQL',
      'MongoDB',
    ],
    links: [
      ProjectLink(
        name: 'GitHub',
        url: 'https://github.com/Pratyush-who/PlugLess-Frontend',
      ),
    ],
  ),
  ProjectModel(
    title: 'Load Balancer',
    description:
        'A scalable load balancer built in Go with pluggable routing algorithms, active and passive health checks, adaptive routing using P2C and EWMA latency, backend metrics, fault detection, and real-time monitoring with Prometheus and Grafana.',
    technologies: [
      'Go',
      'Reverse Proxy',
      'P2C + EWMA',
      'Layer 7 Load Balancing',
      'Health Checks',
      'Outlier Detection',
      'Prometheus',
      'Grafana',
      'Docker',
    ],
    links: [
      ProjectLink(
        name: 'GitHub',
        url: 'https://github.com/Pratyush-who/LoadBalancer-W-RevProxy',
      ),
    ],
  ),
  ProjectModel(
    title: 'Nexus QR',
    description:
        'A QR-based document capture platform built around an optimized media pipeline rather than direct image uploads. Images are resized, scaled and JPEG-compressed on-device before upload, while the Spring Boot backend handles asset metadata, upload references, validation and processing workflows. The system is designed around controlled payloads, memory-efficient image handling and reliable asynchronous media processing.',
    technologies: [
      'Flutter',
      'Dart',
      'Spring Boot',
      'Java',
      'REST APIs',
      'QR Scanning',
      'On-device Image Processing',
      'JPEG Compression',
      'Image Resizing & Scaling',
      'Memory Optimization',
      'Asset Metadata',
      'Upload References',
      'Multipart Uploads',
      'Async Processing',
    ],
    links: [
      ProjectLink(
        name: 'GitHub',
        url: 'https://github.com/Pratyush-who/Nexus-qr-app',
      ),
    ],
  ),
  ProjectModel(
    title: 'LinkedOut',
    status: 'Under Development',
    description:
        'LinkedOut is a social media platform where people openly share career failures, workplace experiences, rejections, and lessons they would not normally post on LinkedIn. It features a scalable social feed with follow/unfollow, communities, posts, images, search, trending topics, and an event-driven backend designed around real system design principles.',
    technologies: [
      'Flutter',
      'Spring Boot',
      'PostgreSQL',
      'Redis',
      'Event-Driven Architecture',
      'Message Queuing',
      'Feed Ranking',
      'Cursor Pagination',
      'Caching',
      'Rate Limiting',
      'FCM',
    ],
    links: [
      ProjectLink(
        name: 'GitHub',
        url: 'https://github.com/Pratyush-who/LinkedOut',
      ),
    ],
  ),
  ProjectModel(
    title: 'Get-Work',
    description:
        'Get-Work is a platform that connects freelancers with clients looking for their skills. It offers a seamless experience for both parties.',
    technologies: [
      'Flutter',
      'Dart',
      'Provider',
      'Multi-role app',
      'Firebase',
      'Cloudinary',
      'FCM',
      'Razorpay',
    ],
    links: [
      ProjectLink(
        name: 'GitHub',
        url: 'https://github.com/Pratyush-who/Get-Work',
      ),
    ],
  ),

  ProjectModel(
    title: 'TrackAI',
    description:
        'TrackAI is a Flutter based fitness tracking app that leverages AI to provide personalized workout recommendations and daily goals also focusing on a multi-themed clean UI in dark and light mode.',
    technologies: ['Flutter', 'Firebase', 'Gemini', 'Dual-Theme'],
    links: [
      ProjectLink(
        name: 'GitHub',
        url: 'https://github.com/Pratyush-who/TrackAI',
      ),
    ],
  ),
];
