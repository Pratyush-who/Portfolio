import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTechCategory('FRONTEND', [
                'Dart',
                'JavaScript',
                'Python',
                'SQL',
                'NoSQL',
              ]),
              const SizedBox(height: 60),
              _buildCurrentlyLearning(),
            ],
          ),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 2,
          child: _buildTechCategory('Frameworks', [
            'Flutter',
            'OpenCV',
            'Selenium',
            'Chrome WebDriver',
            'BeautifulSoup',
            'Finecrawl',
            'Firebase',
            'REST APIs',
            'Google Maps API',
            'Hive',
            'SqfLite',
          ]),
        ),
        const SizedBox(width: 80),
        Expanded(
          flex: 1,
          child: _buildTechCategory('TOOLS', [
            'Git',
            'n8n',
            'Figma',
            'Postman',
            'VS Code',
            'Android Studio',
            'Xcode',
            'Canva',
          ]),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTechCategory('FRONTEND', [
                'Dart',
                'JavaScript',
                'Python',
                'SQL',
                'NoSQL',
              ]),
            ),
            const SizedBox(width: 40),
            Expanded(
              child: _buildTechCategory('TOOLS', [
                'Git',
                'n8n',
                'Figma',
                'Postman',
                'VS Code',
                'Android Studio',
                'Xcode',
                'Canva',
              ]),
            ),
          ],
        ),
        const SizedBox(height: 40),
        _buildTechCategory('Frameworks', [
          'Flutter',
          'OpenCV',
          'Selenium',
          'Chrome WebDriver',
          'BeautifulSoup',
          'Finecrawl',
          'Firebase',
          'REST APIs',
          'Google Maps API',
          'Hive',
          'SqfLite',
        ]),
        const SizedBox(height: 40),
        _buildCurrentlyLearning(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTechCategory('FRONTEND', [
          'Dart',
          'JavaScript',
          'Python',
          'SQL',
          'NoSQL',
        ]),
        const SizedBox(height: 40),
        _buildTechCategory('Frameworks', [
          'Flutter',
          'OpenCV',
          'Selenium',
          'Chrome WebDriver',
          'BeautifulSoup',
          'Finecrawl',
          'Firebase',
          'REST APIs',
          'Google Maps API',
          'Hive',
          'SqfLite',
        ]),
        const SizedBox(height: 40),
        _buildTechCategory('TOOLS', [
          'Git',
          'n8n',
          'Figma',
          'Postman',
          'VS Code',
          'Android Studio',
          'Xcode',
          'Canva',
        ]),
        const SizedBox(height: 40),
        _buildCurrentlyLearning(),
      ],
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

  Widget _buildCurrentlyLearning() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'CURRENTLY LEARNING',
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
          children: ['Gen AI', 'python DSA', 'n8n']
              .map((tech) => _TechChip(technology: tech, isLearning: true))
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