import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:portfolioflutter/homepage.dart';
import 'package:portfolioflutter/preload_service.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _exitController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _exitAnimation;

  // Splash Rive animation
  Artboard? _splashArtboard;
  bool _splashRiveLoaded = false;
  bool _isHovering = false;
  SMIBool? _splashHoverBool;
  SMITrigger? _splashHoverTrigger;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSplashRive();
    _preloadHomePage();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Exit animation
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _exitAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeInOut),
    );
  }

  void _loadSplashRive() async {
    try {
      await RiveFile.initialize();
      final byteData = await rootBundle.load('assets/images/splash.riv');
      final file = RiveFile.import(byteData);
      final artboard = file.mainArtboard;

      // Add controller for animation
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );
      if (controller != null) {
        artboard.addController(controller);
        for (final input in controller.inputs) {
          final name = input.name.toLowerCase();
          if (name.contains('hover')) {
            if (input is SMIBool) {
              _splashHoverBool = input;
            } else if (input is SMITrigger) {
              _splashHoverTrigger = input;
            }
          }
        }
      } else {
        // Fallback to simple animation
        if (artboard.animations.isNotEmpty) {
          final animation = artboard.animations.first;
          final simpleController = SimpleAnimation(animation.name);
          artboard.addController(simpleController);
        }
      }

      setState(() {
        _splashArtboard = artboard;
        _splashRiveLoaded = true;
      });

      // If we found a hover input, pulse it once to show the hover animation
      // on splash even when the user doesn't move the mouse.
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 200), () async {
          _triggerRiveHoverPulse();
        });
      }
    } catch (e) {
      print('Error loading splash Rive: $e');
      setState(() {
        _splashRiveLoaded = false;
      });
    }
  }

  void _preloadHomePage() async {
    // Preload all assets during splash screen
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PreloadService.preloadAssets();
      print('✅ Homepage and assets preloaded successfully');
    } catch (e) {
      print('❌ Error preloading homepage: $e');
    }
  }

  void _startSplashSequence() async {
    // Fade in
    _fadeController.forward();

    // Wait for 5 seconds total
    await Future.delayed(const Duration(seconds: 5));

    // Exit and navigate
    _navigateToHomePage();
  }

  void _navigateToHomePage() async {
    await _exitController.forward();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  void _triggerRiveHoverPulse() {
    // Prefer trigger, then bool toggle if available
    try {
      if (_splashHoverTrigger != null) {
        _splashHoverTrigger!.fire();
        return;
      }
      if (_splashHoverBool != null) {
        // Toggle true briefly
        _splashHoverBool!.value = true;
        Future.delayed(const Duration(milliseconds: 300), () {
          _splashHoverBool!.value = false;
        });
      }
    } catch (e) {
      // ignore errors in case inputs aren't available at runtime
      print('Error triggering Rive hover input: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _exitAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _exitAnimation.value,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF1a1a1a), Colors.black],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Big Rive Animation
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: MouseRegion(
                          onEnter: (_) {
                            setState(() => _isHovering = true);
                            // If the state machine exposes a hover bool, set true.
                            if (_splashHoverBool != null) {
                              _splashHoverBool!.value = true;
                            }
                            // Fire trigger if available
                            if (_splashHoverTrigger != null) {
                              _splashHoverTrigger!.fire();
                            }
                          },
                          onExit: (_) {
                            setState(() => _isHovering = false);
                            if (_splashHoverBool != null) {
                              _splashHoverBool!.value = false;
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            transform: Matrix4.identity()
                              ..scale(_isHovering ? 1.1 : 1.0),
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.8,
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                              maxHeight: 600,
                              minWidth: 350,
                              minHeight: 350,
                            ),
                            child: _splashRiveLoaded && _splashArtboard != null
                                ? Rive(
                                    artboard: _splashArtboard!,
                                    fit: BoxFit.contain,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _isHovering
                                            ? const Color(0xFFFF6B35)
                                            : Colors.grey[700]!,
                                        width: _isHovering ? 3 : 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.animation_outlined,
                                      color: _isHovering
                                          ? const Color(0xFFFF6B35)
                                          : Colors.grey[600],
                                      size: _isHovering ? 100 : 80,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Text below animation
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            "Entering Pratyush-who's Developer World...",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.jetBrainsMono(
                              color: _isHovering
                                  ? const Color(0xFFFF6B35)
                                  : Colors.white,
                              fontSize: _isHovering ? 26 : 24,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                              shadows: _isHovering
                                  ? [
                                      const Shadow(
                                        color: Color(0xFFFF6B35),
                                        blurRadius: 10,
                                        offset: Offset(0, 0),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
