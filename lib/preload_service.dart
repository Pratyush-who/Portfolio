import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class PreloadService {
  static bool _isPreloaded = false;
  static Artboard? _preloadedRiveArtboard;
  static RiveAnimationController? _preloadedRiveController;

  static bool get isPreloaded => _isPreloaded;
  static Artboard? get riveArtboard => _preloadedRiveArtboard;
  static RiveAnimationController? get riveController =>
      _preloadedRiveController;

  static Future<void> preloadAssets() async {
    if (_isPreloaded) return;

    try {
      // Initialize Rive
      await RiveFile.initialize();

      // Preload Rive animation
      final byteData = await rootBundle.load('assets/images/dev.riv');
      final file = RiveFile.import(byteData);
      final artboard = file.mainArtboard;

      // Setup controller
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1',
      );

      if (controller != null) {
        artboard.addController(controller);
        _preloadedRiveController = controller;
      } else {
        // Fallback to simple animation
        final animation = artboard.animations.first;
        _preloadedRiveController = SimpleAnimation(animation.name);
        artboard.addController(_preloadedRiveController!);
      }

      _preloadedRiveArtboard = artboard;
      _isPreloaded = true;

      print('✅ Assets preloaded successfully');
    } catch (e) {
      print('❌ Error preloading assets: $e');
      _isPreloaded = false;
    }
  }

  static void dispose() {
    _preloadedRiveController?.dispose();
    _preloadedRiveController = null;
    _preloadedRiveArtboard = null;
    _isPreloaded = false;
  }
}
