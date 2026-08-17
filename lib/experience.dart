import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Data model ────────────────────────────────────────────────────────────────

class _ExpEntry {
  final String role;
  final String company;
  final String duration;
  final String description;
  final List<String> tags;
  final String? playstoreLink;
  final String? logoUrl;
  final String? logoSvg;
  final String? badge;
  final bool isFreelance;

  const _ExpEntry({
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    required this.tags,
    this.playstoreLink,
    this.logoUrl,
    this.logoSvg,
    this.badge,
    this.isFreelance = false,
  });
}

const _orange = Color(0xFFFF6B35);

const _dramaaniLogoSvg = '''
<svg width="60" height="60" viewBox="47.5 60 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="47.5" y="60" width="60" height="60" rx="9" fill="#1D1D1D"/>
<path d="M70.4899 81.1813V95.1109C68.3643 94.9299 66.7814 93.5731 66.6909 91.7189V77.3823C71.6206 77.3822 74.4698 77.1561 76.912 78.2416C83.2436 81.1813 86.3642 87.4224 83.9673 94.4325C82.0678 99.4073 77.8165 102.347 72.7512 102.664H59.5V77.337C62.2588 77.6536 63.3442 79.1461 63.299 81.8596V98.8194H70.1733C74.6055 98.8194 76.912 98.3671 79.5351 94.8395C81.5251 91.4475 81.3441 87.7842 79.4447 85.0707C77.2307 82.1852 75.1934 81.1813 70.4899 81.1813Z" fill="#FF7F11"/>
<path d="M84.6909 88.9601C84.5726 86.8188 83.9673 85.1159 82.8367 83.2616C86.0929 78.7842 89.8467 77.0204 95.4999 77.3823V98.2314C95.514 100.957 94.4145 102.392 91.7462 102.664V81.3621C88.1103 82.3774 85.7764 84.5279 84.6909 88.9601Z" fill="white"/>
</svg>
''';

final List<_ExpEntry> _entries = [
  _ExpEntry(
    role: 'Junior Flutter Developer',
    company: 'Dramaani',
    duration: 'Apr 2026 – Aug 2026',
    description:
        'Leading development of scalable cross-platform mobile apps, delivering production-ready products with a focus on performance, clean architecture, and real-world reliability.',
    tags: ['Flutter', 'Dart', 'BLoC', 'Firebase', 'REST API'],
    playstoreLink:
        'https://play.google.com/store/apps/details?id=com.facultyfinder.app&hl=en_IN',
    logoSvg: _dramaaniLogoSvg,
  ),
  _ExpEntry(
    role: 'Full Stack Developer',
    company: 'Prepairo',
    duration: 'Jan 2026 – Mar 2026',
    description:
        'Contributed to a 100K+ download production app — Flutter frontend, Spring Boot backend, and Next.js web. Shipped features used daily by thousands of learners.',
    tags: ['Flutter', 'Spring Boot', 'Next.js', 'MongoDB', 'REST API'],
    playstoreLink:
        'https://play.google.com/store/apps/details?id=ai.prepairo.app&hl=en_IN',
    logoUrl: 'https://play-lh.googleusercontent.com/FMQ7TCIDzaeOS7cwNeuyYjjuhGoxW5r-ErpAzuK0OZfFSx8ygz_LsysOTUN3nqNWrb7kA6IYVvK8_GOHOnfWKA=s96-rw',
  ),
  _ExpEntry(
    role: 'Flutter Developer',
    company: 'BazaarGhorr',
    duration: 'Nov 2025 – Jan 2026',
    description:
        'Built and shipped multilingual Customer & Delivery Partner apps from scratch. Led end-to-end product development, REST API integration, and scalable architecture.',
    tags: ['Flutter', 'Firebase', 'Provider', 'Dart', 'REST API'],
    playstoreLink:
        'https://play.google.com/store/apps/details?id=com.bazarghorr.partner&hl=en',
    logoUrl: 'https://play-lh.googleusercontent.com/Kw0LbQMw9PmKV9RKiEMypu0Ag4X6Xpxa8_cZ7N5PUfJOsg9nndSQW8m9yxtArIHGq6l9Y03vEFMPUejTmvXwKQ=w480-h960-rw',
  ),
  _ExpEntry(
    role: 'Frontend Developer',
    company: 'Urban Folks Mobility',
    duration: 'Jul 2025 – Nov 2025',
    description:
        'Designed and built responsive Flutter UIs for a vehicle booking and local bus system. Delivered real-time interfaces that handled live tracking and booking flows.',
    tags: ['Flutter', 'Dart', 'REST API', 'Git', 'Figma'],
    playstoreLink:
        'https://play.google.com/store/apps/details?id=in.allrides.app&hl=en_IN',
    logoUrl: 'https://play-lh.googleusercontent.com/XLp-Mp4V5-s1BMTc0voCHkf1NooNvKYUR8KesPhCufiPAH1wzQPzJP7b0dyd2KU_s70FE5BucrYb3o9Qqz3iuC4=w480-h960-rw',
  ),
  _ExpEntry(
    role: 'Freelance Developer',
    company: 'Independent Projects',
    duration: '2024 – Present',
    description:
        'Closed 4+ freelance projects end-to-end — from mobile apps to backend services. Worked directly with clients across sectors, owning the entire product lifecycle solo.',
    tags: ['Flutter', 'Firebase', 'REST API', 'Dart', 'Kotlin'],
    isFreelance: true,
  ),
];

// ─── Section widget ─────────────────────────────────────────────────────────────

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final isDesktop = w >= 950;
    final horizontalPadding = isMobile ? 20.0 : w * 0.12;

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        isMobile ? 48 : 64,
        horizontalPadding,
        isMobile ? 48 : 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: 'EXPERIENCE'),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            'MY PROFESSIONAL JOURNEY',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: isMobile ? 22 : 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              height: 1.15,
            ),
          ),
          SizedBox(height: isMobile ? 32 : 52),
          isDesktop
              ? _DesktopLayout(entries: _entries)
              : _MobileLayout(entries: _entries),
        ],
      ),
    );
  }
}

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
            color: _orange,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: _orange,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}

// ─── Desktop: staggered two-column layout ──────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  final List<_ExpEntry> entries;
  const _DesktopLayout({required this.entries});

  @override
  Widget build(BuildContext context) {
    final left = <_ExpEntry>[];
    final right = <_ExpEntry>[];
    for (var i = 0; i < entries.length; i++) {
      if (i.isEven) {
        left.add(entries[i]);
      } else {
        right.add(entries[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < left.length; i++)
                _ExpCard(
                  entry: left[i],
                  index: i * 2 + 1,
                  margin: const EdgeInsets.only(bottom: 20),
                ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              // stagger: push right column down slightly
              const SizedBox(height: 64),
              for (var i = 0; i < right.length; i++)
                _ExpCard(
                  entry: right[i],
                  index: i * 2 + 2,
                  margin: const EdgeInsets.only(bottom: 20),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Mobile: single column ──────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  final List<_ExpEntry> entries;
  const _MobileLayout({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          _ExpCard(
            entry: entries[i],
            index: i + 1,
            margin: EdgeInsets.only(bottom: i < entries.length - 1 ? 16 : 0),
          ),
      ],
    );
  }
}

// ─── Card ───────────────────────────────────────────────────────────────────────

class _ExpCard extends StatefulWidget {
  final _ExpEntry entry;
  final int index;
  final EdgeInsets margin;

  const _ExpCard({
    required this.entry,
    required this.index,
    required this.margin,
  });

  @override
  State<_ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<_ExpCard> {
  bool _hovering = false;

  String get _indexStr => widget.index.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 640;
    final e = widget.entry;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: widget.margin,
        decoration: BoxDecoration(
          color: _hovering
              ? const Color(0xFF131313)
              : const Color(0xFF0C0C0C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovering
                ? _orange.withValues(alpha: 0.4)
                : const Color(0xFF222222),
          ),
        ),
        child: Stack(
          children: [
            // Ghost index watermark
            Positioned(
              right: isMobile ? 12 : 18,
              top: isMobile ? 8 : 10,
              child: Text(
                _indexStr,
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white.withValues(alpha: 0.04),
                  fontSize: isMobile ? 64 : 80,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
            // Card content
            Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 22,
                isMobile ? 16 : 20,
                isMobile ? 16 : 22,
                isMobile ? 16 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top row: badge + date + link
                  Row(
                    children: [
                      if (e.badge != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: _orange.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _orange.withValues(alpha: 0.45),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _orange,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                e.badge!,
                                style: GoogleFonts.jetBrainsMono(
                                  color: _orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Expanded(
                        child: Text(
                          e.duration,
                          textAlign: e.badge != null
                              ? TextAlign.start
                              : TextAlign.end,
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white.withValues(alpha: 0.38),
                            fontSize: 12,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      if (!e.isFreelance &&
                          e.playstoreLink != null &&
                          e.playstoreLink!.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        _LinkIconButton(url: e.playstoreLink!),
                      ],
                    ],
                  ),
                  SizedBox(height: isMobile ? 14 : 16),
                  // Logo + title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!e.isFreelance) ...[
                        _LogoBox(
                          url: e.logoUrl,
                          svg: e.logoSvg,
                          name: e.company,
                          size: isMobile ? 42.0 : 48.0,
                        ),
                        SizedBox(width: isMobile ? 12 : 14),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.role,
                              style: GoogleFonts.jetBrainsMono(
                                color: Colors.white,
                                fontSize: isMobile ? 15 : 17,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              e.company,
                              style: GoogleFonts.jetBrainsMono(
                                color: _orange,
                                fontSize: isMobile ? 12 : 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMobile ? 12 : 14),
                  // Description with left accent bar
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 2.5,
                          decoration: BoxDecoration(
                            color: _orange.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.description,
                            style: GoogleFonts.jetBrainsMono(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: isMobile ? 12.5 : 13,
                              height: 1.65,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMobile ? 14 : 16),
                  // Tech chips
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: e.tags.map((t) => _TagChip(label: t)).toList(),
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

// ─── Company logo box ───────────────────────────────────────────────────────────

class _LogoBox extends StatelessWidget {
  final String? url;
  final String? svg;
  final String name;
  final double size;

  const _LogoBox({
    this.url,
    this.svg,
    required this.name,
    required this.size,
  });

  bool get _isPlaceholder {
    if (svg != null && svg!.isNotEmpty) return false;
    return url == null || url!.isEmpty || url!.contains('example.com');
  }

  bool get _isAsset => url != null && url!.startsWith('assets/');

  bool get _isSvgUrl => url != null && url!.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2E2E2E)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: _buildLogo(),
      ),
    );
  }

  Widget _buildLogo() {
    if (svg != null && svg!.isNotEmpty) {
      return SvgPicture.string(svg!, fit: BoxFit.cover);
    }

    if (_isPlaceholder) return _fallback();

    if (_isSvgUrl) {
      if (_isAsset) {
        return SvgPicture.asset(
          url!,
          fit: BoxFit.cover,
          placeholderBuilder: (_) => _fallback(),
        );
      }
      return SvgPicture.network(
        url!,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => _fallback(),
      );
    }

    if (_isAsset) {
      return Image.asset(
        url!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Center(
      child: Text(
        name.substring(0, 1).toUpperCase(),
        style: GoogleFonts.jetBrainsMono(
          color: _orange,
          fontSize: size * 0.36,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── External link icon button ───────────────────────────────────────────────────

class _LinkIconButton extends StatefulWidget {
  final String url;
  const _LinkIconButton({required this.url});

  @override
  State<_LinkIconButton> createState() => _LinkIconButtonState();
}

class _LinkIconButtonState extends State<_LinkIconButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.tryParse(widget.url);
          if (uri != null) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _hovering
                ? _orange.withValues(alpha: 0.15)
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hovering ? _orange : const Color(0xFF2E2E2E),
            ),
          ),
          child: Icon(
            Icons.open_in_new_rounded,
            size: 13,
            color: _hovering ? _orange : Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

// ─── Tag chip ───────────────────────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF2E2E2E)),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          color: Colors.white.withValues(alpha: 0.65),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
