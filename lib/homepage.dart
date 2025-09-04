import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolioflutter/about.dart';
import 'package:portfolioflutter/links.dart';
import 'package:portfolioflutter/project.dart';
import 'package:portfolioflutter/techstack.dart';
import 'package:portfolioflutter/getintouch.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final List<GlobalKey> _sectionKeys = List.generate(
    5,
    (index) => GlobalKey(),
  ); 
  
  final List<String> _sections = [
    'ABOUT',
    'TECHSTACK',
    'PROJECTS',
    'CONTACT',
    'LINKS',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    int newCurrentPage = 0;
    if (scrollOffset > screenHeight * 0.2) newCurrentPage = 1;
    if (scrollOffset > screenHeight * 1.2) newCurrentPage = 2;
    if (scrollOffset > screenHeight * 2.2) newCurrentPage = 3;
    if (scrollOffset > screenHeight * 3.0) newCurrentPage = 4;
    if (scrollOffset > screenHeight * 3.2) newCurrentPage = 5;

    if (newCurrentPage != _currentPage) {
      setState(() {
        _currentPage = newCurrentPage;
      });
    }
  }

  void _navigateToSection(int index) {
    final key = _sectionKeys[index];
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.12,
              vertical: 20,
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: ClipOval(
                        child: Image.network(
                          'https://avatars.githubusercontent.com/u/177855155?v=4&s=256',
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: const Color(0xFF222222),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pratyush-Who',
                      style: GoogleFonts.pixelifySans(
                        color: const Color(0xFFFF6B35),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // On small/mobile widths we remove the top navigation labels
                // to keep the app bar clean. Use 800px as breakpoint.
                if (MediaQuery.of(context).size.width > 800)
                  ...List.generate(_sections.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: _NavTag(
                        label: _sections[index],
                        isActive: _currentPage == index,
                        onTap: () => _navigateToSection(index),
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(key: _sectionKeys[0], child: const AboutSection()),
            const Divider(color: Color(0xFF333333), thickness: 1, height: 1),
            Container(key: _sectionKeys[1], child: const TechstackSection()),
            const Divider(color: Color(0xFF333333), thickness: 1, height: 1),
            Container(key: _sectionKeys[2], child: const ProjectsSection()),
            const Divider(color: Color(0xFF333333), thickness: 1, height: 1),
            Container(
              key: _sectionKeys[3],
              child: const GetInTouchSection(),
            ), // Added GetInTouch section
            const Divider(color: Color(0xFF333333), thickness: 1, height: 1),
            Container(
              key: _sectionKeys[4],
              child: const LinksSection(),
            ), // Moved Links to last
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _NavTag extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTag({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavTag> createState() => _NavTagState();
}

class _NavTagState extends State<_NavTag> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            widget.label,
            style: GoogleFonts.jetBrainsMono(
              color: widget.isActive
                  ? const Color(0xFFFF6B35)
                  : _isHovering
                  ? const Color(0xFFFF6B35)
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
