import 'dart:math';

import 'character_behavior.dart';
import 'character_definition.dart';
import 'sprite_animation.dart';

enum CharacterState {
  idle,
  walking,
  running,
  jumping,
  attacking,
  sayingHi,
}

class PixelCharacter {
  PixelCharacter({
    required this.definition,
    required this.x,
    required this.direction,
    required this.displaySize,
    required Random rng,
  }) : _rng = rng,
       speed = BehaviorConfig.walkSpeed(rng),
       lifetime = 38 + rng.nextDouble() * 36,
       _greetIn = 0.6 + rng.nextDouble() * 2.4 {
    _enter(
      CharacterState.idle,
      Duration(
        milliseconds: BehaviorConfig.idleDuration(rng).inMilliseconds ~/ 2,
      ),
    );
  }

  final PixelCharacterDefinition definition;
  final Random _rng;

  double x;
  int direction;
  double speed;
  double displaySize;
  double jumpY = 0;
  bool leaving = false;
  double age = 0;
  double lifetime;

  CharacterState state = CharacterState.idle;
  late SpriteClip clip;
  int frameIndex = 0;
  double frameElapsed = 0;
  double stateElapsed = 0;
  double stateDuration = 1;

  String? speech;
  double speechOpacity = 0;
  double _greetIn;
  bool _greeted = false;

  bool ready = false;

  double get width => displaySize;

  SpriteClip get _idleClip {
    if (definition.idleAlt != null && _rng.nextBool()) {
      return definition.idleAlt!;
    }
    return definition.idle;
  }

  Future<void> preload(SpriteImageCache cache) async {
    final assets = <String>{
      definition.idle.asset,
      definition.walk.asset,
      if (definition.idleAlt != null) definition.idleAlt!.asset,
      if (definition.run != null) definition.run!.asset,
      if (definition.jump != null) definition.jump!.asset,
      ...definition.attacks.map((a) => a.asset),
    };
    await cache.loadAll(assets);
    ready = cache.get(definition.idle.asset) != null &&
        cache.get(definition.walk.asset) != null;
  }

  void update(double dt, double worldWidth, SpriteImageCache cache) {
    if (!ready || worldWidth <= 0) return;

    age += dt;
    if (!_greeted && !leaving) {
      _greetIn -= dt;
      if (_greetIn <= 0 &&
          state != CharacterState.sayingHi &&
          state != CharacterState.attacking &&
          state != CharacterState.jumping) {
        _greeted = true;
        _enter(CharacterState.sayingHi, BehaviorConfig.hiDuration(_rng));
      }
    }
    if (!leaving && age > lifetime) {
      leaving = true;
      direction = x < worldWidth / 2 ? -1 : 1;
      if (state != CharacterState.walking &&
          state != CharacterState.running) {
        _enter(CharacterState.walking, BehaviorConfig.walkDuration(_rng));
      }
    }

    _advanceAnimation(dt, cache);
    _move(dt, worldWidth);
    _advanceState(dt);
    _updateSpeech(dt);
  }

  void _advanceAnimation(double dt, SpriteImageCache cache) {
    final image = cache.get(clip.asset);
    if (image == null) {
      if (!clip.loop) _onOneShotComplete();
      return;
    }

    final count = frameCountFor(image, definition.frameSize);
    final frameSec = clip.frameDuration.inMilliseconds / 1000.0;
    if (frameSec <= 0) return;

    frameElapsed += dt;
    while (frameElapsed >= frameSec) {
      frameElapsed -= frameSec;
      frameIndex += 1;
      if (frameIndex >= count) {
        if (clip.loop) {
          frameIndex = 0;
        } else {
          frameIndex = count - 1;
          _onOneShotComplete();
          break;
        }
      }
    }

    if (state == CharacterState.jumping) {
      final progress = count <= 1 ? 1.0 : frameIndex / (count - 1);
      jumpY = -sin(progress.clamp(0.0, 1.0) * pi) * (displaySize * 0.28);
    } else {
      jumpY = 0;
    }
  }

  void _move(double dt, double worldWidth) {
    final moving =
        state == CharacterState.walking || state == CharacterState.running;
    if (!moving) return;

    x += direction * speed * dt;
    final maxX = max(0.0, worldWidth - width);

    if (leaving) {
      if (x < -width || x > worldWidth) {
        ready = false;
      }
      return;
    }

    if (x <= 0) {
      x = 0;
      direction = 1;
    } else if (x >= maxX) {
      x = maxX;
      direction = -1;
    }
  }

  void _advanceState(double dt) {
    if (state == CharacterState.jumping || state == CharacterState.attacking) {
      return;
    }

    stateElapsed += dt;
    if (stateElapsed >= stateDuration) {
      _pickNext();
    }
  }

  void _updateSpeech(double dt) {
    if (state == CharacterState.sayingHi) {
      speechOpacity = min(1.0, speechOpacity + dt * 6);
    } else if (speechOpacity > 0) {
      speechOpacity = max(0.0, speechOpacity - dt * 5);
      if (speechOpacity == 0) speech = null;
    }
  }

  void _onOneShotComplete() {
    _enter(CharacterState.walking, BehaviorConfig.walkDuration(_rng));
  }

  void _pickNext() {
    final next = BehaviorConfig.pickNext(
      rng: _rng,
      def: definition,
      current: state,
    );
    switch (next) {
      case CharacterState.walking:
        _enter(next, BehaviorConfig.walkDuration(_rng));
      case CharacterState.idle:
        _enter(next, BehaviorConfig.idleDuration(_rng));
      case CharacterState.running:
        _enter(next, BehaviorConfig.runDuration(_rng));
      case CharacterState.sayingHi:
        _enter(next, BehaviorConfig.hiDuration(_rng));
      case CharacterState.jumping:
      case CharacterState.attacking:
        _enter(next, const Duration(seconds: 8));
    }
  }

  void _enter(CharacterState next, Duration duration) {
    state = next;
    stateElapsed = 0;
    stateDuration = duration.inMilliseconds / 1000.0;
    frameIndex = 0;
    frameElapsed = 0;
    jumpY = 0;

    switch (next) {
      case CharacterState.idle:
        clip = _idleClip;
        speed = 0;
        speech = null;
      case CharacterState.walking:
        clip = definition.walk;
        speed = BehaviorConfig.walkSpeed(_rng);
        speech = null;
      case CharacterState.running:
        clip = definition.run ?? definition.walk;
        speed = BehaviorConfig.runSpeed(_rng);
        speech = null;
      case CharacterState.jumping:
        clip = definition.jump ?? definition.idle;
        speed = 0;
        speech = null;
      case CharacterState.attacking:
        clip = definition.attacks.isEmpty
            ? definition.idle
            : definition.attacks[_rng.nextInt(definition.attacks.length)];
        speed = 0;
        speech = null;
      case CharacterState.sayingHi:
        clip = _idleClip;
        speed = 0;
        speech = BehaviorConfig.randomHi(_rng);
        speechOpacity = 0;
    }
  }
}
