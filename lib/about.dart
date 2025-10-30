import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:portfolioflutter/preload_service.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});
  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  String _currentTime = '';
  Timer? _timer;
  bool _riveError = false;
  bool _riveLoaded = false;
  RiveAnimationController? _animationController;
  RiveAnimationController? _controller;
  Artboard? _artboard;

  // Typewriter animation variables
  late AnimationController _typewriterController;
  late AnimationController _descriptionController;
  late Animation<int> _typewriterAnimation;
  late Animation<double> _descriptionAnimation;
  String _fullText = '\$ flutter_developer --    mobile_specialist';
  String _displayText = '';
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());

    // Initialize animation controllers
    _typewriterController = AnimationController(
      duration: const Duration(
        milliseconds: 3000,
      ), // Slower for more realistic typing
      vsync: this,
    );

    _descriptionController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _typewriterAnimation = IntTween(begin: 0, end: _fullText.length).animate(
      CurvedAnimation(
        parent: _typewriterController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    _descriptionAnimation =
        Tween<double>(
          begin: 30.0, // Start further down
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: _descriptionController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Start animations
    _startTypewriterAnimation();
    _startDescriptionAnimation(); // Start description animation independently
    _startCursorBlinking();
    _loadPreloadedRive(); // Use preloaded Rive instead of loading again
  }

  void _loadPreloadedRive() {
    // Use preloaded assets from PreloadService
    if (PreloadService.isPreloaded) {
      setState(() {
        _artboard = PreloadService.riveArtboard;
        _controller = PreloadService.riveController;
        _riveLoaded = true;
        _riveError = false;
      });
      print('✅ Using preloaded Rive assets');
    } else {
      // Fallback to manual loading if preload failed
      _initializeAndLoadRive();
    }
  }

  void _startTypewriterAnimation() {
    _typewriterAnimation.addListener(() {
      setState(() {
        _displayText = _fullText.substring(0, _typewriterAnimation.value);
      });
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _typewriterController.forward();
    });
  }

  void _startDescriptionAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      _descriptionController.forward();
    });
  }

  void _startCursorBlinking() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _showCursor = !_showCursor;
      });
    });
  }

  void _initializeAndLoadRive() async {
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
      } else {
        // Fallback to simple animation if state machine not found
        final animation = artboard.animations.first;
        _controller = SimpleAnimation(animation.name);
        artboard.addController(_controller!);
      }

      if (mounted) {
        setState(() {
          _artboard = artboard;
          _riveLoaded = true;
          _riveError = false;
        });
      }
    } catch (e) {
      print('Error loading Rive animation: $e');
      if (mounted) {
        setState(() {
          _riveError = true;
          _riveLoaded = false;
        });
      }
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    _typewriterController.dispose();
    _descriptionController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
      'Building AboutSection, Rive error: $_riveError, loaded: $_riveLoaded',
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth > 800;

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.black,
          constraints: BoxConstraints(minHeight: screenHeight * 0.6),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.12,
              10,
              screenWidth * 0.12,
              10,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 2, child: _buildContent()),
                      const SizedBox(width: 60),
                      Expanded(flex: 2, child: _buildAnimationSection()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContent(),
                      const SizedBox(height: 30),
                      _buildAnimationSection(),
                    ],
                  ),
          ),
        ),
        // Small spacing box above divider
        Container(width: double.infinity, height: 20, color: Colors.black),
      ],
    );
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isDesktop ? 450 : screenWidth * 0.9,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Typewriter effect for main title
          Row(
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _displayText,
                        style: GoogleFonts.jetBrainsMono(
                          color: Colors.white,
                          fontSize: isDesktop ? 28 : 20,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      if (_showCursor)
                        TextSpan(
                          text: '_',
                          style: GoogleFonts.jetBrainsMono(
                            color: const Color(0xFFFF6B35),
                            fontSize: isDesktop ? 28 : 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Animated description text
          AnimatedBuilder(
            animation: _descriptionAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _descriptionAnimation.value),
                child: AnimatedOpacity(
                  opacity: _descriptionController.isCompleted ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
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
              );
            },
          ),
          const SizedBox(height: 24),
          // Animated status row
          AnimatedBuilder(
            animation: _descriptionAnimation,
            builder: (context, child) {
              return AnimatedOpacity(
                opacity: _descriptionController.isCompleted ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: _buildStatusRow(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border.all(color: Colors.grey[600]!, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
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
        ),
        const SizedBox(width: 28),
        _buildOpenToWorkButton(),
      ],
    );
  }

  Widget _buildOpenToWorkButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          // Add your contact action here
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovering ? const Color(0xFFFF6B35) : Colors.transparent,
            border: Border.all(color: const Color(0xFFFF6B35), width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Open to work',
            style: GoogleFonts.jetBrainsMono(
              color: _isHovering ? Colors.black : const Color(0xFFFF6B35),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    double animationSize = isDesktop
        ? (screenWidth * 0.24).clamp(280, 420)
        : (screenWidth * 0.58).clamp(220, 350);

    return Container(
      width: animationSize,
      height: animationSize,
      child: _buildRiveAnimation(),
    );
  }

  Widget _buildRiveAnimation() {
    // If preloaded, show immediately without loading animation
    if (PreloadService.isPreloaded && _artboard != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovering ? const Color(0xFFFF6B35) : Colors.grey[600]!,
              width: _isHovering ? 3 : 2,
            ),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.2),
                      blurRadius: 35,
                      spreadRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[900]),
              child: Rive(artboard: _artboard!, fit: BoxFit.cover),
            ),
          ),
        ),
      );
    }

    if (_riveError) {
      return _buildFallbackAnimation();
    }

    if (!_riveLoaded || _artboard == null) {
      return _buildLoadingPlaceholder();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovering ? const Color(0xFFFF6B35) : Colors.grey[600]!,
            width: _isHovering ? 3 : 2,
          ),
          boxShadow: _isHovering
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withOpacity(0.2),
                    blurRadius: 35,
                    spreadRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[900]),
            child: Rive(artboard: _artboard!, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[600]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Color(0xFFFF6B35),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Animation...',
              style: GoogleFonts.jetBrainsMono(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAnimation() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[600]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.animation_outlined,
              size: 64,
              color: const Color(0xFFFF6B35),
            ),
            const SizedBox(height: 16),
            Text(
              'Animation\nNot Available',
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: Colors.grey[400],
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
