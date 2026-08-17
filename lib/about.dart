import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolioflutter/preload_service.dart';
import 'package:rive/rive.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});
  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _descriptionController;
  late final Animation<double> _descriptionAnimation;

  @override
  void initState() {
    super.initState();
    _descriptionController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _descriptionAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _descriptionController, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _descriptionController.forward();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 800;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.black,
          constraints: BoxConstraints(minHeight: size.height * 0.6),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              size.width * 0.12,
              10,
              size.width * 0.12,
              10,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: _buildContent(isDesktop, size.width)),
                      const SizedBox(width: 60),
                      const Expanded(flex: 2, child: _RiveHero()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContent(isDesktop, size.width),
                      const SizedBox(height: 30),
                      const _RiveHero(),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContent(bool isDesktop, double screenWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 450 : screenWidth * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TypewriterTitle(isDesktop: isDesktop),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _descriptionAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _descriptionAnimation.value),
                child: child,
              );
            },
            child: FadeTransition(
              opacity: _descriptionController,
              child: Text(
                'Hi, I am Pratyush Mehra, a Flutter App Developer building cross-platform mobile applications. Specializing in state management, UI/UX design, and scalable app architecture. Building random stuff that somehow makes sense.',
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.grey[300],
                  fontSize: isDesktop ? 16 : 14,
                  height: 1.6,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          FadeTransition(
            opacity: _descriptionController,
            child: const _StatusRow(),
          ),
        ],
      ),
    );
  }
}

class _TypewriterTitle extends StatefulWidget {
  final bool isDesktop;
  const _TypewriterTitle({required this.isDesktop});

  @override
  State<_TypewriterTitle> createState() => _TypewriterTitleState();
}

class _TypewriterTitleState extends State<_TypewriterTitle>
    with SingleTickerProviderStateMixin {
  static const _fullText = '\$ flutter_developer --    mobile_specialist';
  late final AnimationController _controller;
  late final Animation<int> _animation;
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = IntTween(begin: 0, end: _fullText.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _showCursor = !_showCursor);
    });
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.isDesktop ? 28.0 : 20.0;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: _fullText.substring(0, _animation.value),
                style: GoogleFonts.jetBrainsMono(
                  color: Colors.white,
                  fontSize: size,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              if (_showCursor)
                TextSpan(
                  text: '_',
                  style: GoogleFonts.jetBrainsMono(
                    color: const Color(0xFFFF6B35),
                    fontSize: size,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _LiveClock(),
        SizedBox(width: 28),
        _OpenToWorkButton(),
      ],
    );
  }
}

class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  Timer? _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final now = DateTime.now();
    final next =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    if (next != _currentTime && mounted) {
      setState(() => _currentTime = next);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border.all(color: Colors.grey[600]!, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 8,
            height: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _currentTime,
            style: GoogleFonts.jetBrainsMono(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenToWorkButton extends StatefulWidget {
  const _OpenToWorkButton();

  @override
  State<_OpenToWorkButton> createState() => _OpenToWorkButtonState();
}

class _OpenToWorkButtonState extends State<_OpenToWorkButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _hovering ? const Color(0xFFFF6B35) : Colors.transparent,
          border: Border.all(color: const Color(0xFFFF6B35), width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'Open to work',
          style: GoogleFonts.jetBrainsMono(
            color: _hovering ? Colors.black : const Color(0xFFFF6B35),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _RiveHero extends StatefulWidget {
  const _RiveHero();

  @override
  State<_RiveHero> createState() => _RiveHeroState();
}

class _RiveHeroState extends State<_RiveHero> {
  bool _hovering = false;
  bool _riveError = false;
  bool _riveLoaded = false;
  RiveAnimationController? _controller;
  Artboard? _artboard;

  @override
  void initState() {
    super.initState();
    if (PreloadService.isPreloaded) {
      _artboard = PreloadService.riveArtboard;
      _controller = PreloadService.riveController;
      _riveLoaded = _artboard != null;
    } else {
      _initializeAndLoadRive();
    }
  }

  Future<void> _initializeAndLoadRive() async {
    try {
      await RiveFile.initialize();
      final byteData = await rootBundle.load('assets/images/dev.riv');
      final file = RiveFile.import(byteData);
      final artboard = file.mainArtboard;
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );
      if (controller != null) {
        artboard.addController(controller);
        _controller = controller;
      } else if (artboard.animations.isNotEmpty) {
        _controller = SimpleAnimation(artboard.animations.first.name);
        artboard.addController(_controller!);
      }
      if (!mounted) return;
      setState(() {
        _artboard = artboard;
        _riveLoaded = true;
        _riveError = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _riveError = true;
        _riveLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 800;
    final animationSize = isDesktop
        ? (width * 0.24).clamp(280.0, 420.0)
        : (width * 0.58).clamp(220.0, 350.0);

    return SizedBox(
      width: animationSize,
      height: animationSize,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_riveError) return _placeholder(icon: Icons.animation_outlined);
    if (!_riveLoaded || _artboard == null) {
      return _placeholder(loading: true);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovering ? const Color(0xFFFF6B35) : Colors.grey[600]!,
            width: _hovering ? 3 : 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ColoredBox(
            color: Colors.grey[900]!,
            child: RepaintBoundary(
              child: Rive(
                artboard: _artboard!,
                fit: BoxFit.cover,
                antialiasing: false,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder({bool loading = false, IconData? icon}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[600]!, width: 2),
      ),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B35),
                  strokeWidth: 3,
                ),
              )
            : Icon(icon, size: 64, color: const Color(0xFFFF6B35)),
      ),
    );
  }
}
