import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _assetsReady = false;

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
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _exitController = AnimationController(
      duration: const Duration(milliseconds: 500),
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
          break;
        }
      }
      if (controller == null && artboard.animations.isNotEmpty) {
        artboard.addController(SimpleAnimation(artboard.animations.first.name));
      }

      if (!mounted) return;
      setState(() {
        _splashArtboard = artboard;
        _splashController = controller;
        _splashRiveLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _splashRiveLoaded = false);
    }
  }

  void _onRiveHover(bool hovering) {
    if (_splashController == null || _isHoveringRive == hovering) return;
    _isHoveringRive = hovering;

    for (final input in _splashController!.inputs) {
      if (input is SMIBool &&
          _hoverInputNames.any(
            (name) => name.toLowerCase() == input.name.toLowerCase(),
          )) {
        input.value = hovering;
        return;
      }
    }

    for (final input in _splashController!.inputs) {
      if (input is SMITrigger &&
          _hoverInputNames.any(
            (name) => name.toLowerCase() == input.name.toLowerCase(),
          )) {
        if (hovering) input.fire();
        return;
      }
    }

    for (final input in _splashController!.inputs) {
      if (input is SMIBool) {
        input.value = hovering;
      }
    }
  }

  Future<void> _startSplashSequence() async {
    _fadeController.forward();

    // Keep splash on screen for at least 3 seconds so users can play with it,
    // and wait until homepage assets (Rive, fonts, sprites) are ready.
    await Future.wait([
      PreloadService.preloadAssets().timeout(
        const Duration(seconds: 8),
        onTimeout: () {},
      ),
      Future<void>.delayed(const Duration(seconds: 3)),
    ]);

    if (!mounted) return;
    setState(() => _assetsReady = true);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!mounted) return;
    await _navigateToHomePage();
  }

  Future<void> _navigateToHomePage() async {
    await _exitController.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomePage(),
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
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
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _exitAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: (size.width * 0.8).clamp(350.0, 600.0),
                  height: (size.width * 0.8).clamp(350.0, 600.0),
                  child: _splashRiveLoaded && _splashArtboard != null
                      ? MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => _onRiveHover(true),
                          onExit: (_) => _onRiveHover(false),
                          child: Rive(
                            artboard: _splashArtboard!,
                            fit: BoxFit.contain,
                            antialiasing: false,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 40),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  _assetsReady
                      ? "Entering Pratyush-who's Developer World..."
                      : '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
