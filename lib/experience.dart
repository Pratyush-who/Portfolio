import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final horizontalPadding = isMobile ? 24.0 : w * 0.12;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        60,
        horizontalPadding,
        60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPERIENCE',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 40),
          const _RoadmapTimeline(),
        ],
      ),
    );
  }
}

class _RoadmapTimeline extends StatelessWidget {
  const _RoadmapTimeline();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> experiences = [
      {
        'role': 'Junior Flutter Developer',
        'company': 'Dramaani',
        'duration': 'April 2026 - August 2026',
        'description':
            'Leading the development of scalable cross-platform mobile applications, delivering high-quality products for clients with a focus on performance, usability, and reliable production-ready solutions .',
        'playstoreLink':
            'https://play.google.com/store/apps/details?id=com.facultyfinder.app&hl=en_IN',
      },
      {
        'role': 'Full Stack Developer',
        'company': 'Prepairo',
        'duration': 'January 2026 - March 2026',
        'description':
            'Worked on a production mobile application with 100K+ downloads, contributing to the Flutter frontend and Spring Boot backend, along with Next.js web development .',
        'playstoreLink':
            'https://play.google.com/store/apps/details?id=ai.prepairo.app&hl=en_IN',
      },
      {
        'role': 'Flutter Developer',
        'company': 'BazaarGhorr',
        'duration': 'Nov 2025 - January 2026',
        'description':
            'Built and delivered multilingual Customer and Delivery Partner apps with Flutter, contributing to product ideation, end-to-end workflows, REST API integrations, and scalable architecture using system design principles.',
        'playstoreLink':
            'https://play.google.com/store/apps/details?id=com.bazarghorr.partner&hl=en_IN',
      },
      {
        'role': 'Frontend Developer',
        'company': 'Urban Folks Mobility',
        'duration': 'July 2025 - November 2025',
        'description':
            'Designed and developed responsive, user-friendly interfaces for a vehicle booking and local bus booking system using Flutter and Dart, with a focus on seamless user experience and real-time functionality.',
        'playstoreLink':
            'https://play.google.com/store/apps/details?id=in.allrides.app&hl=en_IN',
      },
    ];

    return Stack(
      children: [
        // Continuous background line
        Positioned(
          left: 7,
          top: 32,
          bottom: 100, // Leave room for indicator
          child: Container(width: 2, color: const Color(0xFF333333)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(experiences.length, (index) {
              final data = experiences[index];
              return _TimelineItem(
                role: data['role']!,
                company: data['company']!,
                duration: data['duration']!,
                description: data['description']!,
                playstoreLink: data['playstoreLink'],
              );
            }),
            // "+X more" indicator
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 16),
              child: Text(
                '+4 more experiences...',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineItem extends StatefulWidget {
  final String role;
  final String company;
  final String duration;
  final String description;
  final String? playstoreLink;

  const _TimelineItem({
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    this.playstoreLink,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Node
        Container(
          margin: const EdgeInsets.only(top: 32), // Align with title
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovering ? const Color(0xFFFF6B35) : Colors.black,
              border: Border.all(
                color: _isHovering
                    ? const Color(0xFFFF6B35)
                    : Colors.grey[700]!,
                width: 2,
              ),
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Content Card
        Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _isHovering
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovering
                      ? const Color(0xFFFF6B35).withOpacity(0.3)
                      : Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.role,
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (widget.playstoreLink != null &&
                          widget.playstoreLink!.isNotEmpty)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              final uri = Uri.tryParse(widget.playstoreLink!);
                              if (uri != null) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6B35).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF6B35,
                                  ).withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons
                                        .shop, // Represents play store well enough
                                    color: Color(0xFFFF6B35),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Play Store',
                                    style: GoogleFonts.jetBrainsMono(
                                      color: const Color(0xFFFF6B35),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      Text(
                        widget.company,
                        style: GoogleFonts.jetBrainsMono(
                          color: const Color(0xFFFF6B35),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.duration,
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: GoogleFonts.jetBrainsMono(
                      color: Colors.grey[400],
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
