import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:super_quest/actors/ember.dart';
import 'package:super_quest/actors/water_enemy.dart';
import 'package:super_quest/managers/segment_manager.dart';
import 'package:super_quest/objects/ground_block.dart';
import 'package:super_quest/objects/platform_block.dart';
import 'package:super_quest/objects/star.dart';
import 'package:flutter/material.dart';
import 'package:super_quest/overlays/hud.dart';
import 'package:flame_audio/flame_audio.dart';

class EmberQuestGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  EmberQuestGame();

  late EmberPlayer _ember;
  double objectSpeed = 0.0;
  final Vector2 velocity = Vector2.zero();
  int starsCollected = 0;
  int health = 3;
  late double lastBlockXPosition = 0.0;
  late UniqueKey lastBlockKey;
  late AudioPool pool;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'block.png',
      'ember.png',
      'ground.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'hero.png',
      'skater.png',
      'lucas.png',
    ]);
    // FlameAudio.bgm.initialize();

    await FlameAudio.audioCache.load('fundo.mp3');

    // var home_map = await TiledComponent.load('back.png', Vector2.all(32));
    // add(home_map);
    startBgmMusic();
    initializeGame(true);
    // Faz o Ember iniciar caindo
    _ember = EmberPlayer(
      position: Vector2(28, canvasSize.y - 128),
    );
    add(Hud());

  }


  void loadGameSegments(int segmentIndex, double xPositionOffset) {

    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
          add(GroundBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case PlatformBlock:
          add(PlatformBlock(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case Star:
          add(Star(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
        case WaterEnemy:
          add(WaterEnemy(
            gridPosition: block.gridPosition,
            xOffset: xPositionOffset,
          ));
          break;
      }
    }
  }

  void initializeGame(bool loadHud) {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 128),
    );
    add(_ember);
    if (loadHud) {
      add(Hud());
    }
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  Image addBackground(BuildContext context, List<Widget> stackWidgets) {
    return Image.asset('assets/images/heart.png');
  }



  void reset() {
    starsCollected = 0;
    health = 3;
    initializeGame(false);
  }

  @override
  void update(double dt) {
    if (health <= 0) {
      overlays.add('GameOver');
    }
    super.update(dt);
  }
  void startBgmMusic() {
    FlameAudio.bgm.initialize();
    // FlameAudio.bgm.play('fundo.mp3', volume: 0.2);
    //  pool.start();
  }


}

