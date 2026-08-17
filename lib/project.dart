import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 640;
    final horizontalPadding = isMobile ? 20.0 : screenWidth * 0.12;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          isMobile ? 48 : 60,
          horizontalPadding,
          isMobile ? 48 : 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SectionLabel(label: 'PROJECTS'),
            SizedBox(height: isMobile ? 6 : 8),
            Text(
              'WHAT I\'VE BUILT',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: isMobile ? 22 : 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                height: 1.15,
              ),
            ),
            SizedBox(height: isMobile ? 28 : 48),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final crossAxisCount = w >= 1100
                    ? 3
                    : w >= 720
                    ? 2
                    : 1;
                const gap = 16.0;
                final itemWidth = crossAxisCount == 1
                    ? w
                    : (w - (crossAxisCount - 1) * gap) / crossAxisCount;
                // Fixed card height so all cards are consistent.
                // Mobile stays auto-height; multi-col uses a fixed min height.
                final cardHeight = crossAxisCount == 1 ? null : 290.0;

                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: List.generate(_projects.length, (index) {
                    return SizedBox(
                      width: itemWidth,
                      height: cardHeight,
                      child: _ProjectCard(
                        project: _projects[index],
                        index: index + 1,
                        fixedHeight: cardHeight != null,
                      ),
                    );
                  }),
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
  final int index;
  final bool fixedHeight;

  const _ProjectCard({
    required this.project,
    required this.index,
    this.fixedHeight = false,
  });

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

  void _showProjectDetails() {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.72),
        builder: (context) {
          return _ProjectDetailSheet(
            project: widget.project,
            onOpenUrl: _openUrl,
          );
        },
      );
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.72),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, anim1, anim2) {
        final dialogHeight =
            (MediaQuery.of(context).size.height * 0.78).clamp(420.0, 640.0);
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 560,
              height: dialogHeight,
              child: _ProjectDetailPanel(
                project: widget.project,
                onOpenUrl: _openUrl,
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(
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
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final techs = widget.project.technologies;
    // Always cap at 4 visible chips so all cards occupy one chip row
    const visibleCount = 4;
    final visibleTechs = techs.take(visibleCount).toList();
    final remaining = techs.length - visibleTechs.length;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _showProjectDetails,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.fromLTRB(
            isMobile ? 16 : 20,
            isMobile ? 16 : 20,
            isMobile ? 16 : 20,
            isMobile ? 16 : 18,
          ),
          decoration: BoxDecoration(
            color: _isHovering
                ? const Color(0xFF121212)
                : const Color(0xFF0C0C0C),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovering
                  ? const Color(0xFFFF6B35).withValues(alpha: 0.4)
                  : const Color(0xFF222222),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // When fixed height: fill the box, push links to bottom.
            // When auto height (mobile): wrap content naturally.
            mainAxisSize: widget.fixedHeight
                ? MainAxisSize.max
                : MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    widget.index.toString().padLeft(2, '0'),
                    style: GoogleFonts.jetBrainsMono(
                      color: const Color(0xFFFF6B35),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  if (widget.project.status != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.55),
                        ),
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
              const SizedBox(height: 12),
              Text(
                widget.project.title,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: isMobile ? 17 : 18,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.project.description,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white.withValues(alpha: 0.58),
                  fontSize: 13,
                  height: 1.55,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              // Push chips + links to bottom when card is fixed height
              if (widget.fixedHeight) const Spacer(),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...visibleTechs.map((tech) => _TechChip(label: tech)),
                  if (remaining > 0) _TechChip(label: '+$remaining', muted: true),
                ],
              ),
              if (widget.project.links.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: widget.project.links
                      .map(
                        (link) => _LinkButton(
                          text: link.name,
                          onTap: () => _openUrl(link.url),
                        ),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailSheet extends StatelessWidget {
  final ProjectModel project;
  final Future<void> Function(String url) onOpenUrl;

  const _ProjectDetailSheet({
    required this.project,
    required this.onOpenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final sheetHeight = MediaQuery.of(context).size.height * 0.82;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: sheetHeight,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0C0C0C),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Expanded(
                  child: _ProjectDetailPanel(
                    project: project,
                    onOpenUrl: onOpenUrl,
                    isSheet: true,
                    bottomPadding: bottomInset + 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectDetailPanel extends StatelessWidget {
  final ProjectModel project;
  final Future<void> Function(String url) onOpenUrl;
  final bool isSheet;
  final double bottomPadding;

  const _ProjectDetailPanel({
    required this.project,
    required this.onOpenUrl,
    this.isSheet = false,
    this.bottomPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 640;
    final h = isNarrow ? 20.0 : 28.0;
    final topPad = isSheet ? 16.0 : 24.0;

    return Container(
      width: double.infinity,
      decoration: isSheet
          ? null
          : BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF242424)),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── top bar: • PROJECT  ×  ───────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(h, topPad, h, 0),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B35),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'PROJECT',
                      style: GoogleFonts.jetBrainsMono(
                        color: const Color(0xFFFF6B35),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      '×',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 26,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── large title ───────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(h, 14, h, 0),
            child: Text(
              project.title.toUpperCase(),
              style: GoogleFonts.jetBrainsMono(
                color: Colors.white,
                fontSize: isNarrow ? 28 : 36,
                fontWeight: FontWeight.w800,
                height: 1.05,
                letterSpacing: 0.6,
              ),
            ),
          ),

          // ── subtitle with left orange bar ─────────────────────
          if (project.subtitle != null) ...[
            const SizedBox(height: 14),
            Padding(
              padding: EdgeInsets.only(left: h),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: h),
                        child: Text(
                          project.subtitle!,
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: isNarrow ? 13 : 14,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── scrollable body ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(h, 2, h, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.description,
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.white.withValues(alpha: 0.62),
                      fontSize: isNarrow ? 13 : 13.5,
                      height: 1.72,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFF1E1E1E), height: 1),
                  const SizedBox(height: 20),
                  // • TECH STACK
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B35),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TECH STACK',
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies
                        .map((tech) => _DetailTechChip(label: tech))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── footer: links ─────────────────────────────────────
          if (project.links.isNotEmpty) ...[
            const Divider(color: Color(0xFF1E1E1E), height: 1),
            Padding(
              padding: EdgeInsets.fromLTRB(
                h,
                14,
                h,
                isSheet ? bottomPadding : 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: project.links
                    .map(
                      (link) => _DetailLinkButton(
                        text: link.name,
                        onTap: () => onOpenUrl(link.url),
                      ),
                    )
                    .toList(),
              ),
            ),
          ] else
            SizedBox(height: isSheet ? bottomPadding : 12),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final bool muted;

  const _TechChip({required this.label, this.muted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: muted ? const Color(0xFF3A3A3A) : const Color(0xFF3F3F3F),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          color: muted
              ? Colors.white.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.82),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─── Detail-panel tech chip (with orange dot prefix) ──────────────────────────

class _DetailTechChip extends StatelessWidget {
  final String label;
  const _DetailTechChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF2E2E2E)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B35),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Detail-panel link button ─────────────────────────────────────────────────

class _DetailLinkButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _DetailLinkButton({required this.text, required this.onTap});

  @override
  State<_DetailLinkButton> createState() => _DetailLinkButtonState();
}

class _DetailLinkButtonState extends State<_DetailLinkButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovering ? Colors.white : const Color(0xFFFF6B35);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'VIEW ON ${widget.text.toUpperCase()}',
              style: GoogleFonts.jetBrainsMono(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.open_in_new_rounded, color: color, size: 14),
          ],
        ),
      ),
    );
  }
}

// ─── Card link button ─────────────────────────────────────────────────────────

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
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          '${widget.text} →',
          style: GoogleFonts.jetBrainsMono(
            color: _isHovering ? const Color(0xFFFF6B35) : Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─── Section label (mirrors experience.dart) ───────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '// ',
          style: GoogleFonts.jetBrainsMono(
            color: const Color(0xFFFF6B35),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: const Color(0xFFFF6B35),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}

class ProjectModel {
  final String title;
  final String? subtitle;
  final String description;
  final List<String> technologies;
  final List<ProjectLink> links;
  final String? status;

  ProjectModel({
    required this.title,
    this.subtitle,
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
    subtitle: 'Scalable Discord-like social platform',
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
    subtitle: 'High-performance Go reverse proxy with adaptive routing',
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
    subtitle: 'QR-based document capture with optimized media pipeline',
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
    subtitle: 'Anti-LinkedIn social platform for real career stories',
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
    subtitle: 'Freelancer-client marketplace with real-time features',
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
    subtitle: 'AI-powered fitness tracker with personalized goal engine',
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
