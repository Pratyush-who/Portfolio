import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Single source-of-truth for tech categories and currently-learning list.
// Categories: Languages, Frontend, Backend, Databases, Tools
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 768;

    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.12,
          60,
          screenWidth * 0.12,
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
                fontSize: screenWidth < 768 ? 24 : 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
            isDesktop
                ? _buildDesktopLayout()
                : isTablet
                ? _buildTabletLayout()
                : _buildMobileLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoriesGrid(crossAxisCount: 3, childAspectRatio: 1.7),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTabletLayout() {
    // Tablet: 2-column grid
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoriesGrid(crossAxisCount: 2, childAspectRatio: 1.6),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildMobileLayout() {
    // Mobile: single column grid (effectively stacked)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoriesGrid(crossAxisCount: 1, childAspectRatio: 3.5),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCategoriesGrid({
    required int crossAxisCount,
    double childAspectRatio = 1.6,
  }) {
    final categories = [
      'FRONTEND',
      'BACKEND',
      'DATABASES',
      'TOOLS',
      'LANGUAGES',
    ];

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 40,
      crossAxisSpacing: 40,
      childAspectRatio: childAspectRatio,
      children: categories.map((key) {
        final list = techStack[key] ?? <String>[];
        return _buildTechCategory(key, list);
      }).toList(),
    );
  }

  Widget _buildTechCategory(String title, List<String> technologies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: technologies
              .map((tech) => _TechChip(technology: tech))
              .toList(),
        ),
      ],
    );
  }

}

class _TechChip extends StatefulWidget {
  final String technology;
  final bool isLearning;

  const _TechChip({required this.technology, this.isLearning = false});

  @override
  State<_TechChip> createState() => _TechChipState();
}

class _TechChipState extends State<_TechChip> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
            width: 1.5,
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
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
