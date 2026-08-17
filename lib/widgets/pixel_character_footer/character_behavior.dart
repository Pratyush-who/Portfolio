import 'dart:math';

import 'character_definition.dart';
import 'pixel_character.dart';

/// Weighted probabilities and timing. Tweak these to change the vibe.
class BehaviorConfig {
  static const int walkWeight = 48;
  static const int idleWeight = 16;
  static const int runWeight = 10;
  static const int jumpWeight = 5;
  static const int hiWeight = 18;
  static const int attackWeight = 3;

  static const List<String> hiMessages = [
    'Hii',
    'Ohio',
    'Namaste',
    'Konichiwa',
    'Hire me',
    'Duhh',
    'GAY',
    ':)',
    'Hello qt',
    'TMKC',
    'Hihihihihi',
    'Sojao dost'
  ];

  static Duration walkDuration(Random rng) =>
      Duration(milliseconds: 2500 + rng.nextInt(5500));

  static Duration idleDuration(Random rng) =>
      Duration(milliseconds: 900 + rng.nextInt(2600));

  static Duration runDuration(Random rng) =>
      Duration(milliseconds: 1100 + rng.nextInt(1700));

  static Duration hiDuration(Random rng) =>
      Duration(milliseconds: 1800 + rng.nextInt(1400));

  static double walkSpeed(Random rng) => 26 + rng.nextDouble() * 16;

  static double runSpeed(Random rng) => 70 + rng.nextDouble() * 22;

  static CharacterState pickNext({
    required Random rng,
    required PixelCharacterDefinition def,
    required CharacterState current,
  }) {
    final options = <(CharacterState, int)>[
      (CharacterState.walking, walkWeight),
      (CharacterState.idle, idleWeight),
      if (def.canRun) (CharacterState.running, runWeight),
      if (def.canJump && current != CharacterState.jumping)
        (CharacterState.jumping, jumpWeight),
      if (current != CharacterState.sayingHi)
        (CharacterState.sayingHi, hiWeight),
      if (def.canAttack && current != CharacterState.attacking)
        (CharacterState.attacking, attackWeight),
    ];

    final total = options.fold<int>(0, (sum, o) => sum + o.$2);
    var roll = rng.nextInt(total);
    for (final option in options) {
      roll -= option.$2;
      if (roll < 0) return option.$1;
    }
    return CharacterState.walking;
  }

  static final List<String> _hiQueue = [];

  static String randomHi(Random rng) {
    if (_hiQueue.isEmpty) {
      _hiQueue
        ..addAll(hiMessages)
        ..shuffle(rng);
    }
    return _hiQueue.removeLast();
  }
}
