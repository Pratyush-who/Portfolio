import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 24.0,
                  runSpacing: 24.0,
                  children: _projects.map((project) {
                    final double itemWidth = screenWidth > 1200
                        ? (constraints.maxWidth - 48) / 3
                        : screenWidth > 800
                        ? (constraints.maxWidth - 24) / 2
                        : constraints.maxWidth;
                    return SizedBox(
                      width: itemWidth,
                      child: _ProjectCard(project: project),
                    );
                  }).toList(),
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovering ? 1.02 : 1.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(
              color: _isHovering ? const Color(0xFFFF6B35) : Colors.grey[700]!,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.project.title,
                      style: GoogleFonts.jetBrainsMono(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
              const SizedBox(height: 16),
              Text(
                widget.project.description,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[300],
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Wrap(
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
              if (widget.project.links.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  children: widget.project.links
                      .map(
                        (link) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _LinkButton(
                            text: link.name,
                            onTap: () {
                              // Handle link tap
                            },
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
    );
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
    title: 'Butterflix',
    description:
        'Butterflix is an online movie streaming platform that lets you watch the latest films and shows anytime, anywhere, with a smooth and user-friendly experience.',
    technologies: [
      'Flutter',
      'Dart',
      'Riverpod',
      'Firebase',
      'Localization',
      'FCM',
      'Android Native Channel',
      'Platform-specific Tools',
    ],
    links: [ProjectLink(name: 'Play Store', url: '#')],
  ),
  ProjectModel(
    title: 'Pesto',
    description:
        'Developed a smart recipe app (Pesto) with offline-first support using SqfLite & Hive. Integrated an AI model that analyzes user eating patterns and suggests personalized dishes for the day.',
    technologies: [
      'Flutter',
      'Riverpod',
      'Supabase',
      'sqfLite',
      'Hive',
      'Firebase',
      'Twilio',
      'swift',
      'Platform-specific Tools',
    ],
    links: [
      ProjectLink(name: 'Play Store', url: '#'),
      ProjectLink(name: 'App Store', url: '#'),
    ],
  ),
  ProjectModel(
    title: 'Bulk Result Downloader',
    description:
        'I was free enjoying vacation then college results came out so out of curiosity made Python-based CLI tool to download student results in bulk from university portals. It automates fetching results using roll numbers, saving hours of manual work on result day.',
    technologies: ['Python', 'Requests', 'BeautifulSoup', 'Automation', 'CLI'],
    links: [ProjectLink(name: 'GitHub', url: '#')],
  ),
  ProjectModel(
    title: 'Waka Ride',
    status: 'Under Development',
    description:
        'Waka Ride is a cab-sharing and mobility app built for South...',
    technologies: ['Flutter', 'Firebase', 'Google Maps'],
    links: [],
  ),
  ProjectModel(
    title: 'WordPress',
    description:
        'Built a WordPress & SEO service business with my friend, scaling it from zero to ₹50K+/month. I managed...',
    technologies: ['WordPress', 'SEO', 'Business'],
    links: [],
  ),
];
