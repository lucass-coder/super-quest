import 'package:flame/game.dart';
import 'package:super_quest/actors/ember.dart';
import 'package:super_quest/actors/water_enemy.dart';
import 'package:super_quest/managers/segment_manager.dart';
import 'package:super_quest/objects/ground_block.dart';
import 'package:super_quest/objects/platform_block.dart';
import 'package:super_quest/objects/star.dart';
import 'package:flutter/material.dart';

class EmberQuestGame extends FlameGame {
  EmberQuestGame();

  late EmberPlayer _ember;
  double objectSpeed = 0.0;
  final Vector2 velocity = Vector2.zero();


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
    ]);
    initializeGame();
    // _ember = EmberPlayer(
    //   position: Vector2(128, canvasSize.y - 70),
    // );
    // add(_ember);
  }


  void loadGameSegments(int segmentIndex, double xPositionOffset) {

    for (final block in segments[segmentIndex]) {
      switch (block.blockType) {
        case GroundBlock:
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

  void initializeGame() {
    // Assume that size.x < 3200
    final segmentsToLoad = (size.x / 640).ceil();
    segmentsToLoad.clamp(0, segments.length);

    for (var i = 0; i <= segmentsToLoad; i++) {
      loadGameSegments(i, (640 * i).toDouble());
    }

    _ember = EmberPlayer(
      position: Vector2(128, canvasSize.y - 70),
    );
    add(_ember);
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 173, 223, 247);
  }

  @override
  Image addBackground(BuildContext context, List<Widget> stackWidgets) {
    return Image.asset('assets/images/heart.png');
  }




}