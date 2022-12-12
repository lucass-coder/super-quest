import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:super_quest/actors/ember.dart';

import '../ember_quest.dart';


class GroundBlock extends SpriteComponent
    with HasGameRef<EmberQuestGame> {
  final Vector2 gridPosition;
  double xOffset;

  double objectSpeed = 0.0;
  final Vector2 velocity = Vector2.zero();

  GroundBlock({
    required this.gridPosition,
    required this.xOffset,
  }) : super(size: Vector2.all(64), anchor: Anchor.bottomLeft);

  @override
  Future<void> onLoad() async {
    final platformImage = game.images.fromCache('ground.png');
    sprite = Sprite(platformImage);
    position = Vector2((gridPosition.x * size.x) + xOffset,
      game.size.y - (gridPosition.y * size.y),

    );
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
  @override
  void update(double dt) {
    velocity.x = game.objectSpeed;
    position += velocity * dt;
    if (position.x < -size.x) removeFromParent();

    if (game.health <= 0) {
      removeFromParent();
    }

    super.update(dt);
  }
}