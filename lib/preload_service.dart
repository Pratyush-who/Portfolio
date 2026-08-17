import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

import 'widgets/pixel_character_footer/character_definition.dart';
import 'widgets/pixel_character_footer/sprite_animation.dart';

class PreloadService {
  static bool _isPreloaded = false;
  static bool _warming = false;
  static Artboard? _preloadedRiveArtboard;
  static RiveAnimationController? _preloadedRiveController;
  static final SpriteImageCache spriteCache = SpriteImageCache();

  static const avatarUrl =
      'https://avatars.githubusercontent.com/u/177855155?v=4&s=256';

  static bool get isPreloaded => _isPreloaded;
  static Artboard? get riveArtboard => _preloadedRiveArtboard;
  static RiveAnimationController? get riveController =>
      _preloadedRiveController;

  /// Only what the first screen needs. Sprites warm up after homepage paints.
  static Future<void> preloadAssets() async {
    if (_isPreloaded) return;

    try {
      await RiveFile.initialize();
      await Future.wait([
        _preloadRive(),
        _preloadFonts(),
        _precacheNetworkImage(avatarUrl),
      ]);
      _isPreloaded = true;
    } catch (_) {
      _isPreloaded = _preloadedRiveArtboard != null;
    }
  }

  /// Decode character sheets in small chunks so the UI thread stays free.
  static Future<void> warmupIdle() async {
    if (_warming) return;
    _warming = true;
    final assets = pixelCharacterWarmAssets(limit: 6);
    for (var i = 0; i < assets.length; i += 2) {
      await spriteCache.loadAll(assets.skip(i).take(2));
      await Future<void>.delayed(const Duration(milliseconds: 40));
    }
  }

  static Future<void> _preloadRive() async {
    final byteData = await rootBundle.load('assets/images/dev.riv');
    final file = RiveFile.import(byteData);
    final artboard = file.mainArtboard;

    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );

    if (controller != null) {
      artboard.addController(controller);
      _preloadedRiveController = controller;
    } else if (artboard.animations.isNotEmpty) {
      _preloadedRiveController = SimpleAnimation(artboard.animations.first.name);
      artboard.addController(_preloadedRiveController!);
    }

    _preloadedRiveArtboard = artboard;
  }

  static Future<void> _preloadFonts() async {
    GoogleFonts.jetBrainsMono();
    GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w700);
    GoogleFonts.pixelifySans(fontWeight: FontWeight.bold);
    await GoogleFonts.pendingFonts();
  }

  static Future<void> _precacheNetworkImage(String url) {
    final stream = NetworkImage(url).resolve(const ImageConfiguration());
    final completer = Completer<void>();
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (image, _) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete();
      },
      onError: (_, __) {
        stream.removeListener(listener);
        if (!completer.isCompleted) completer.complete();
      },
    );
    stream.addListener(listener);
    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {},
    );
  }

  static void dispose() {
    _preloadedRiveController?.dispose();
    _preloadedRiveController = null;
    _preloadedRiveArtboard = null;
    spriteCache.dispose();
    _isPreloaded = false;
    _warming = false;
  }
}
