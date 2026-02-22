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

  Artboard? _splashArtboard;
  StateMachineController? _splashController;
  bool _splashRiveLoaded = false;
  bool _isHoveringRive = false;

  // Known hover input names to try
  static const _hoverInputNames = [
    'Hover',
    'hover',
    'isHover',
    'isHovered',
    'Hovered',
    'hovered',
    'MouseOver',
    'mouseOver',
    'mouse_over',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSplashRive();
    _preloadHomePage();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

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

      StateMachineController? controller;
      for (final sm in artboard.stateMachines) {
        final c = StateMachineController.fromArtboard(artboard, sm.name);
        if (c != null) {
          artboard.addController(c);
          controller = c;
          // Print all inputs for debugging
          for (final input in c.inputs) {
            print('🎮 Rive input: "${input.name}" (${input.runtimeType})');
          }
          break;
        }
      }
      if (controller == null && artboard.animations.isNotEmpty) {
        artboard.addController(SimpleAnimation(artboard.animations.first.name));
      }

      setState(() {
        _splashArtboard = artboard;
        _splashController = controller;
        _splashRiveLoaded = true;
      });
    } catch (e) {
      print('Error loading splash Rive: $e');
      setState(() {
        _splashRiveLoaded = false;
      });
    }
  }

  void _onRiveHover(bool hovering) {
    if (_splashController == null || _isHoveringRive == hovering) return;
    _isHoveringRive = hovering;

    for (final input in _splashController!.inputs) {
      // Try boolean inputs matching known hover names
      if (input is SMIBool &&
          _hoverInputNames.any(
            (name) => name.toLowerCase() == input.name.toLowerCase(),
          )) {
        input.value = hovering;
        return;
      }
    }

    // Fallback: fire trigger with hover-like name
    for (final input in _splashController!.inputs) {
      if (input is SMITrigger &&
          _hoverInputNames.any(
            (name) => name.toLowerCase() == input.name.toLowerCase(),
          )) {
        if (hovering) input.fire();
        return;
      }
    }

    // Last fallback: toggle all boolean inputs
    for (final input in _splashController!.inputs) {
      if (input is SMIBool) {
        input.value = hovering;
      }
    }
  }

  void _preloadHomePage() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PreloadService.preloadAssets();
      print('✅ Homepage and assets preloaded successfully');
    } catch (e) {
      print('❌ Error preloading homepage: $e');
    }
  }

  void _startSplashSequence() async {
    _fadeController.forward();
    await Future.delayed(const Duration(seconds: 5));
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
    _splashController?.dispose();
    super.dispose();
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
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                            maxHeight: 600,
                            minWidth: 350,
                            minHeight: 350,
                          ),
                          child: _splashRiveLoaded && _splashArtboard != null
                              ? MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) => _onRiveHover(true),
                                  onExit: (_) => _onRiveHover(false),
                                  child: Rive(
                                    artboard: _splashArtboard!,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey[700]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.animation_outlined,
                                    color: Colors.grey[600],
                                    size: 80,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          "Entering Pratyush-who's Developer World...",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jetBrainsMono(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
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
