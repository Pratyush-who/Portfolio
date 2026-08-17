/// Static character + clip metadata.
///
/// Frame counts are derived at runtime from the PNG width and [frameSize].
/// All character sheets in this pack are 128px-tall horizontal strips of
/// square frames.
class SpriteClip {
  final String asset;
  final Duration frameDuration;
  final bool loop;

  const SpriteClip({
    required this.asset,
    this.frameDuration = const Duration(milliseconds: 100),
    this.loop = true,
  });
}

class PixelCharacterDefinition {
  final String name;
  final SpriteClip idle;
  final SpriteClip walk;
  final SpriteClip? idleAlt;
  final SpriteClip? run;
  final SpriteClip? jump;
  final List<SpriteClip> attacks;

  /// Source frame size in pixels (square).
  final int frameSize;

  const PixelCharacterDefinition({
    required this.name,
    required this.idle,
    required this.walk,
    this.idleAlt,
    this.run,
    this.jump,
    this.attacks = const [],
    this.frameSize = 128,
  });

  bool get canRun => run != null;
  bool get canJump => jump != null;
  bool get canAttack => attacks.isNotEmpty;
}

SpriteClip _clip(
  String folder,
  String file, {
  int ms = 100,
  bool loop = true,
}) {
  return SpriteClip(
    asset: 'assets/characters/$folder/$file',
    frameDuration: Duration(milliseconds: ms),
    loop: loop,
  );
}

PixelCharacterDefinition _def(
  String folder, {
  bool run = true,
  bool jump = false,
  bool idleAlt = false,
  int attackCount = 0,
  bool singleAttack = false,
}) {
  return PixelCharacterDefinition(
    name: folder,
    idle: _clip(folder, 'Idle.png', ms: 120),
    idleAlt: idleAlt ? _clip(folder, 'Idle_2.png', ms: 120) : null,
    walk: _clip(folder, 'Walk.png', ms: 90),
    run: run ? _clip(folder, 'Run.png', ms: 70) : null,
    jump: jump ? _clip(folder, 'Jump.png', ms: 80, loop: false) : null,
    attacks: [
      if (singleAttack) _clip(folder, 'Attack.png', ms: 85, loop: false),
      ...List.generate(
        attackCount,
        (i) => _clip(folder, 'Attack_${i + 1}.png', ms: 85, loop: false),
      ),
    ],
  );
}

List<String> pixelCharacterWarmAssets({int limit = 6}) {
  final assets = <String>{};
  for (final def in kPixelCharacters.take(limit)) {
    assets.add(def.idle.asset);
    assets.add(def.walk.asset);
  }
  return assets.toList();
}

/// Every character folder present under `assets/characters/`.
final List<PixelCharacterDefinition> kPixelCharacters = [
  _def('Kunoichi', jump: true, attackCount: 2),
  _def('Kitsune', jump: true, idleAlt: true, attackCount: 3),
  _def('Karasu_tengu', jump: true, idleAlt: true, attackCount: 3),
  _def('Yamabushi_tengu', jump: true, idleAlt: true, attackCount: 3),
  _def('Gorgon_1', idleAlt: true, attackCount: 3),
  _def('Gorgon_2', idleAlt: true, attackCount: 3),
  _def('Gorgon_3', idleAlt: true, attackCount: 3),
  _def('Onre', attackCount: 3),
  _def('Yurei', attackCount: 4),
  _def('Satyr_1', run: false, singleAttack: true),
  _def('Satyr_2', run: false, singleAttack: true),
  _def('Satyr_3', run: false, singleAttack: true),
];
