import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Single source-of-truth for tech categories
final Map<String, List<String>> techStack = {
  'FRONTEND': [
    'Flutter',
    'React',
    'TailwindCSS',
    'Bootstrap',
    'HTML5',
    'CSS3',
    'JavaScript',
  ],
  'BACKEND': ['Spring Boot', 'Node.js', 'REST APIs', 'JWT'],
  'DATABASES': ['Firebase', 'PostgreSQL', 'MongoDB', 'Supabase', 'Hive'],
  'TOOLS': ['Git', 'GitHub', 'Postman', 'VS Code', 'Android Studio'],
  'LANGUAGES': ['Java', 'Dart', 'JavaScript', 'Python', 'SQL'],
};

class TechstackSection extends StatelessWidget {
  const TechstackSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;
    final isTablet = w >= 640 && w < 1024;

    final horizontalPadding = isMobile ? 24.0 : w * 0.12;

    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        60,
        horizontalPadding,
        60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TECHSTACK',
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 36),
          _ResponsiveCategories(
            crossAxisCount: isMobile
                ? 1
                : isTablet
                ? 2
                : 3,
          ),
        ],
      ),
    );
  }
}

class _ResponsiveCategories extends StatelessWidget {
  final int crossAxisCount;
  const _ResponsiveCategories({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'FRONTEND',
      'BACKEND',
      'DATABASES',
      'TOOLS',
      'LANGUAGES',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 40.0;
        final width = constraints.maxWidth;
        final itemWidth = crossAxisCount == 1
            ? width
            : (width - (crossAxisCount - 1) * gap) / crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: categories.map((key) {
            final techs = techStack[key] ?? [];
            return SizedBox(
              width: itemWidth,
              child: _TechCategoryCard(title: key, technologies: techs),
            );
          }).toList(),
        );
      },
    );
  }
}

class _TechCategoryCard extends StatelessWidget {
  final String title;
  final List<String> technologies;

  const _TechCategoryCard({required this.title, required this.technologies});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 640;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: technologies
                .map((t) => _TechChip(technology: t, compact: isMobile))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatefulWidget {
  final String technology;
  final bool isLearning;
  final bool compact;

  const _TechChip({
    required this.technology,
    this.isLearning = false,
    this.compact = false,
  });

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.compact ? 12.0 : 14.0;
    final vPad = widget.compact ? 4.0 : 5.0;
    final hPad = widget.compact ? 10.0 : 12.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: _isHovering
              ? const Color(0xFFFF6B35).withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: widget.isLearning
                ? const Color(0xFFFF6B35)
                : _isHovering
                ? const Color(0xFFFF6B35)
                : Colors.grey[600]!,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          widget.technology,
          style: GoogleFonts.jetBrainsMono(
            color: widget.isLearning
                ? const Color(0xFFFF6B35)
                : _isHovering
                ? const Color(0xFFFF6B35)
                : Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
