import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../preload_service.dart';
import 'character_definition.dart';
import 'pixel_character.dart';
import 'sprite_animation.dart';

class PixelCharacterFooter extends StatefulWidget {
  const PixelCharacterFooter({
    super.key,
    this.characterCount = 12,
    this.height = 132,
  });

  final int characterCount;
  final double height;

  @override
  State<PixelCharacterFooter> createState() => _PixelCharacterFooterState();
}

class _PixelCharacterFooterState extends State<PixelCharacterFooter>
    with SingleTickerProviderStateMixin {
  final SpriteImageCache _cache = PreloadService.spriteCache;
  final List<PixelCharacter> _characters = [];
  final Random _rng = Random();
  final _FooterTick _repaint = _FooterTick();

  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  double _worldWidth = 0;
  int _targetCount = 0;
  double _nextSpawnIn = 0.2;
  bool _started = false;
  late final _FooterCharactersPainter _painter;

  static const _webFrame = 1 / 30;

  @override
  void initState() {
    super.initState();
    _painter = _FooterCharactersPainter(
      characters: _characters,
      cache: _cache,
      repaint: _repaint,
    );
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _repaint.dispose();
    super.dispose();
  }

  int _countForWidth(double width) {
    final maxCount = widget.characterCount;
    if (width < 420) return min(3, maxCount);
    if (width < 640) return min(6, maxCount);
    if (width < 980) return min(9, maxCount);
    return min(12, maxCount);
  }

  double _displaySizeForWidth(double width) {
    if (width < 640) return 48;
    if (width < 980) return 56;
    return 64;
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    if (_lastElapsed == Duration.zero) {
      _lastElapsed = elapsed;
      return;
    }
    var dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    if (dt <= 0) return;
    if (kIsWeb && dt < _webFrame) return;
    _lastElapsed = elapsed;
    dt = dt.clamp(0.0, 0.05);

    if (_worldWidth <= 0) return;

    _targetCount = _countForWidth(_worldWidth);
    _nextSpawnIn -= dt;
    _characters.removeWhere((c) => c.leaving && !c.ready);

    if (_characters.length < _targetCount && _nextSpawnIn <= 0) {
      _spawnCharacter();
      // Fill the strip quickly, then slow down for replacements.
      final filling = _characters.length < _targetCount;
      _nextSpawnIn = filling
          ? 0.18 + _rng.nextDouble() * 0.22
          : 2.2 + _rng.nextDouble() * 2.8;
    }

    for (final character in _characters) {
      character.update(dt, _worldWidth, _cache);
    }

    _repaint.tick();
  }

  Future<void> _spawnCharacter() async {
    if (!mounted || _worldWidth <= 0) return;

    final used = _characters.map((c) => c.definition.name).toSet();
    final pool =
        kPixelCharacters.where((d) => !used.contains(d.name)).toList();
    final source = pool.isEmpty ? kPixelCharacters : pool;
    final def = source[_rng.nextInt(source.length)];
    final size = _displaySizeForWidth(_worldWidth);
    final maxX = max(0.0, _worldWidth - size);

    var x = _rng.nextDouble() * maxX;
    for (var attempt = 0; attempt < 8; attempt++) {
      final crowded = _characters.any((c) => (c.x - x).abs() < size * 1.35);
      if (!crowded) break;
      x = _rng.nextDouble() * maxX;
    }

    final character = PixelCharacter(
      definition: def,
      x: x,
      direction: _rng.nextBool() ? 1 : -1,
      displaySize: size,
      rng: Random(),
    );

    _characters.add(character);
    await character.preload(_cache);
    if (!mounted) return;
    if (!character.ready) {
      _characters.remove(character);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: ColoredBox(
          color: const Color(0xFF050505),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (context, constraints) {
                _worldWidth = constraints.maxWidth;
                if (!_started && _worldWidth > 0) {
                  _started = true;
                  _targetCount = _countForWidth(_worldWidth);
                }
                return CustomPaint(
                  size: Size(constraints.maxWidth, widget.height),
                  painter: _painter,
                  isComplex: true,
                  willChange: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterCharactersPainter extends CustomPainter {
  _FooterCharactersPainter({
    required this.characters,
    required this.cache,
    super.repaint,
  });

  final List<PixelCharacter> characters;
  final SpriteImageCache cache;

  final _groundPaint = Paint()
    ..color = const Color(0xFF1A1A1A)
    ..strokeWidth = 1;

  final _spritePaint = Paint()
    ..filterQuality = FilterQuality.none
    ..isAntiAlias = false;

  final _shadowPaint = Paint()..color = const Color(0x44000000);

  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height - 6;
    canvas.drawLine(
      Offset(0, groundY),
      Offset(size.width, groundY),
      _groundPaint,
    );

    for (final character in characters) {
      if (!character.ready) continue;
      _paintCharacter(canvas, character, groundY, size);
    }
  }

  void _paintCharacter(
    Canvas canvas,
    PixelCharacter character,
    double groundY,
    Size canvasSize,
  ) {
    final image = cache.get(character.clip.asset);
    if (image == null) return;

    final frameSize = character.definition.frameSize.toDouble();
    final count = frameCountFor(image, character.definition.frameSize);
    final frame = character.frameIndex.clamp(0, count - 1);
    final src = Rect.fromLTWH(frame * frameSize, 0, frameSize, frameSize);

    final destH = character.displaySize;
    final destW = destH;
    final dest = Rect.fromLTWH(
      character.x,
      groundY - destH + character.jumpY,
      destW,
      destH,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(dest.center.dx, groundY - 1),
        width: destW * 0.42,
        height: 5,
      ),
      _shadowPaint,
    );

    canvas.save();
    if (character.direction < 0) {
      canvas.translate(dest.center.dx, 0);
      canvas.scale(-1, 1);
      canvas.translate(-dest.center.dx, 0);
    }
    canvas.drawImageRect(image, src, dest, _spritePaint);
    canvas.restore();

    if (character.speech != null && character.speechOpacity > 0) {
      _paintSpeech(
        canvas,
        dest,
        character.speech!,
        character.speechOpacity,
        canvasSize.width,
      );
    }
  }

  void _paintSpeech(
    Canvas canvas,
    Rect characterRect,
    String text,
    double opacity,
    double maxWidth,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color.fromRGBO(20, 20, 20, opacity),
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const padH = 7.0;
    const padV = 4.0;
    final bubbleSize = Size(tp.width + padH * 2, tp.height + padV * 2);
    var left = characterRect.center.dx - bubbleSize.width / 2;
    var top = characterRect.top - bubbleSize.height - 6;
    left = left.clamp(4.0, max(4.0, maxWidth - bubbleSize.width - 4));
    top = max(4.0, top);

    final bubbleRect = Rect.fromLTWH(left, top, bubbleSize.width, bubbleSize.height);

    final rrect = RRect.fromRectAndRadius(bubbleRect, const Radius.circular(3));
    final fill = Paint()..color = Color.fromRGBO(245, 245, 245, opacity);
    final stroke = Paint()
      ..color = Color.fromRGBO(40, 40, 40, opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(rrect, fill);
    canvas.drawRRect(rrect, stroke);

    final tip = Path()
      ..moveTo(bubbleRect.center.dx - 3.5, bubbleRect.bottom)
      ..lineTo(bubbleRect.center.dx, bubbleRect.bottom + 4.5)
      ..lineTo(bubbleRect.center.dx + 3.5, bubbleRect.bottom)
      ..close();
    canvas.drawPath(tip, fill);
    canvas.drawPath(tip, stroke);

    tp.paint(canvas, Offset(bubbleRect.left + padH, bubbleRect.top + padV));
  }

  @override
  bool? hitTest(Offset position) => false;

  @override
  bool shouldRepaint(covariant _FooterCharactersPainter oldDelegate) => false;
}

class _FooterTick extends ChangeNotifier {
  void tick() => notifyListeners();
}
