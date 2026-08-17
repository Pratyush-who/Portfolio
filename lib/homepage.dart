import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolioflutter/about.dart';
import 'package:portfolioflutter/experience.dart';
import 'package:portfolioflutter/getintouch.dart';
import 'package:portfolioflutter/links.dart';
import 'package:portfolioflutter/preload_service.dart';
import 'package:portfolioflutter/project.dart';
import 'package:portfolioflutter/techstack.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);
  final ValueNotifier<bool> _aboutActive = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _footerActive = ValueNotifier<bool>(false);
  final List<GlobalKey> _sectionKeys = List.generate(6, (index) => GlobalKey());

  static const _sections = [
    'ABOUT',
    'TECHSTACK',
    'EXPERIENCE',
    'PROJECTS',
    'CONTACT',
    'LINKS',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onScroll();
      _revealRest();
    });
  }

  int _builtCount = 1;

  Future<void> _revealRest() async {
    await WidgetsBinding.instance.endOfFrame;
    PreloadService.warmupIdle();
    while (_builtCount < 6 && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 70));
      if (!mounted) return;
      setState(() => _builtCount++);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final h = pos.viewportDimension;
    final offset = pos.pixels;

    var page = 0;
    if (offset > h * 0.2) page = 1;
    if (offset > h * 1.2) page = 2;
    if (offset > h * 2.2) page = 3;
    if (offset > h * 3.2) page = 4;
    if (offset > h * 4.0) page = 5;
    if (_currentPage.value != page) _currentPage.value = page;

    final aboutOn = offset < h * 1.25;
    if (_aboutActive.value != aboutOn) _aboutActive.value = aboutOn;

    final max = pos.maxScrollExtent;
    final footerOn = max <= 0 ? false : offset > max - h * 1.85;
    if (_footerActive.value != footerOn) _footerActive.value = footerOn;
  }

  Future<void> _navigateToSection(int index) async {
    if (_builtCount <= index) {
      setState(() => _builtCount = index + 1);
      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    final ctx = _sectionKeys[index].currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      alignment: 0,
    );
    _onScroll();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.12, vertical: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: ClipOval(
                        child: Image.network(
                          PreloadService.avatarUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.medium,
                          gaplessPlayback: true,
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
                if (w > 800)
                  ValueListenableBuilder<int>(
                    valueListenable: _currentPage,
                    builder: (context, page, _) {
                      return Row(
                        children: List.generate(_sections.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: _NavTag(
                              label: _sections[index],
                              isActive: page == index,
                              onTap: () => _navigateToSection(index),
                            ),
                          );
                        }),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            for (var i = 0; i < _builtCount; i++) ...[
              if (i > 0)
                const Divider(color: Color(0xFF333333), thickness: 1, height: 1),
              _buildSection(i),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(int index) {
    late final Widget child;
    switch (index) {
      case 0:
        child = ValueListenableBuilder<bool>(
          valueListenable: _aboutActive,
          builder: (context, active, nested) {
            return TickerMode(enabled: active, child: nested!);
          },
          child: const AboutSection(),
        );
      case 1:
        child = const TechstackSection();
      case 2:
        child = const ExperienceSection();
      case 3:
        child = const ProjectsSection();
      case 4:
        child = const GetInTouchSection();
      default:
        child = LinksSection(animationsEnabled: _footerActive);
    }

    return RepaintBoundary(
      child: KeyedSubtree(
        key: _sectionKeys[index],
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _currentPage.dispose();
    _aboutActive.dispose();
    _footerActive.dispose();
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
