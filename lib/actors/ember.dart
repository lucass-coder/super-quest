import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/services.dart';

import 'package:super_quest/actors/water_enemy.dart';
import 'package:super_quest/ember_quest.dart';
import 'package:super_quest/objects/star.dart';
import '../objects/ground_block.dart';
import '../objects/platform_block.dart';

class EmberPlayer extends SpriteAnimationComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<EmberQuestGame> {
  EmberPlayer({
    required super.position,
  }) : super(
      size: Vector2(70
          ,150),
      anchor: Anchor.center,
  );

  final Vector2 velocity = Vector2.zero();
  final Vector2 fromAbove = Vector2(0, -1);
  final double gravity = 10;
  final double jumpSpeed = 600;
  final double moveSpeed = 200;
  final double terminalVelocity = 150;
  int horizontalDirection = 0;
  String avatar = 'lucas.png';

  bool hasJumped = false;
  bool hitByEnemy = false;
  bool isOnGround = false;

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(avatar),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(120,420),
        stepTime: 0.12,
      ),
    );

    add(
      CircleHitbox(),
    );
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    hasJumped = (keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)
    );


    return true;
  }

  @override
  void update(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    game.objectSpeed = 0;
    // Prevent ember from going backwards at screen edge.
    if (position.x - 36 <= 0 && horizontalDirection < 0) {
      velocity.x = 0;
    }
    // Prevent ember from going beyond half screen.
    if (position.x + 64 >= game.size.x / 2 && horizontalDirection > 0) {
      velocity.x = 0;
      game.objectSpeed = -moveSpeed;
    }

    // Apply basic gravity.
    velocity.y += gravity;

    // Determine if ember has jumped.
    if (hasJumped) {
      avatar = 'lucas-pulo.png';
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(avatar),
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(120,420),
          stepTime: 0.12,
        ),
      );
      if (isOnGround) {
        print('IS GROMP');
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      print('NÃÃÃÃO IS GROMP');
      hasJumped = false;
    }

    // Prevent ember from jumping to crazy fast.
    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);

    // TOPO do PULO
    if(velocity.y == 0){
      print('Velocidade igual a zero');
      avatar = 'lucas-desce.png';
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache(avatar),
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2(120,420),
          stepTime: 0.12,
        ),
      );
    }


    // Adjust ember position.
    position += velocity * dt;


    // print('LINHA 126: ${velocity.x}');

    // If ember fell in pit, then game over.
    if (position.y > game.size.y + size.y) {
      game.health = 0;
    }

    if (game.health <= 0) {
      removeFromParent();
    }

    // Flip ember if needed.
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is GroundBlock || other is PlatformBlock) {
      if (intersectionPoints.length == 2) {
        // Calculate the collision normal and separation distance.
        final mid = (intersectionPoints.elementAt(0) +
                intersectionPoints.elementAt(1)) /
            2;

        final collisionNormal = absoluteCenter - mid;
        final separationDistance = (size.x / 2) - collisionNormal.length;
        collisionNormal.normalize();

        // If collision normal is almost upwards,
        // ember must be on ground.
        // Detecta Boneco no chão
        if (fromAbove.dot(collisionNormal) > 0.9) {

            avatar = 'lucas.png';
            animation = SpriteAnimation.fromFrameData(
              game.images.fromCache(avatar),
              SpriteAnimationData.sequenced(
                amount: 1,
                textureSize: Vector2(120,420),
                stepTime: 0.12,
              ),
            );


          isOnGround = true;
        }

        // Resolve collision by moving ember along
        // collision normal by separation distance.
        position += collisionNormal.scaled(separationDistance);
      }
    }

    if (other is Star) {
      other.removeFromParent();
    }

    if (other is WaterEnemy) {
      hit();
    }

    if (other is Star) {
      other.removeFromParent();
      game.starsCollected++;
    }

    super.onCollision(intersectionPoints, other);
  }

  void hit() {
    if (!hitByEnemy) {
      game.health--;
      hitByEnemy = true;
    }
    add(
      OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          hitByEnemy = false;
        },
    );
  }
}
