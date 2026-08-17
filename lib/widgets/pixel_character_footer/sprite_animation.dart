import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Loads and caches full sprite-sheet PNGs as [ui.Image]s.
class SpriteImageCache {
  final Map<String, ui.Image> _images = {};
  final Set<String> _failed = {};
  final Map<String, Future<ui.Image?>> _inFlight = {};

  ui.Image? get(String asset) => _images[asset];

  bool hasFailed(String asset) => _failed.contains(asset);

  Future<ui.Image?> load(String asset) {
    final cached = _images[asset];
    if (cached != null) return Future.value(cached);
    if (_failed.contains(asset)) return Future.value(null);

    return _inFlight.putIfAbsent(asset, () async {
      try {
        final data = await rootBundle.load(asset);
        final codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(),
        );
        final frame = await codec.getNextFrame();
        _images[asset] = frame.image;
        return frame.image;
      } catch (e, st) {
        _failed.add(asset);
        debugPrint('PixelCharacterFooter: failed to load $asset\n$e\n$st');
        return null;
      } finally {
        _inFlight.remove(asset);
      }
    });
  }

  Future<void> loadAll(Iterable<String> assets) async {
    await Future.wait(assets.map(load));
  }

  void dispose() {
    for (final image in _images.values) {
      image.dispose();
    }
    _images.clear();
    _failed.clear();
    _inFlight.clear();
  }
}

int frameCountFor(ui.Image image, int frameSize) {
  if (frameSize <= 0) return 1;
  final count = image.width ~/ frameSize;
  return count < 1 ? 1 : count;
}
