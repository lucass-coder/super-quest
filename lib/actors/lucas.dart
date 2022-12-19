import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:super_quest/ember_quest.dart';

enum LucasState {
  duck,
  cair, // Cair
  parado, // Parado
  salto, // saltar
  caminhar, // Caminhar
}

class Lucas extends BodyComponent with KeyboardHandler {
  final _size = Vector2(1.80, 2.4);
  final _componentPosition = Vector2(0, -.325);
  LucasState state = LucasState.parado;


  late final SpriteComponent duckComponent;
  late final SpriteComponent cairComponent;
  late final SpriteComponent paradoComponent;
  late final SpriteComponent saltoComponent;
  late final SpriteAnimationComponent caminharComponent;

  late Component atualComponent;

  int accelerationX = 0;
  bool isDucking = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    final duck = await gameRef.loadSprite('robot/robot_duck.png');
    final fall = await gameRef.loadSprite('robot/robot_fall.png');
    final idle = await gameRef.loadSprite('robot/robot_idle.png');
    final jump = await gameRef.loadSprite('robot/robot_jump.png');
    final walk0 = await gameRef.loadSprite('robot/robot_walk0.png');
    final walk1 = await gameRef.loadSprite('robot/robot_walk1.png');
    final walk2 = await gameRef.loadSprite('robot/robot_walk2.png');
    final walk3 = await gameRef.loadSprite('robot/robot_walk3.png');
    final walk4 = await gameRef.loadSprite('robot/robot_walk4.png');
    final walk5 = await gameRef.loadSprite('robot/robot_walk5.png');
    final walk6 = await gameRef.loadSprite('robot/robot_walk6.png');
    final walk7 = await gameRef.loadSprite('robot/robot_walk7.png');

    duckComponent = SpriteComponent(
      sprite: duck,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    cairComponent = SpriteComponent(
      sprite: fall,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    paradoComponent = SpriteComponent(
      sprite: idle,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    saltoComponent = SpriteComponent(
      sprite: jump,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    final walkAnimation = SpriteAnimation.spriteList([
      walk0,
      walk1,
      walk2,
      walk3,
      walk4,
      walk5,
      walk6,
      walk7,
    ], stepTime: 0.05, loop: true);

    caminharComponent = SpriteAnimationComponent(
        animation: walkAnimation,
        anchor: Anchor.center,
        position: _componentPosition,
        size: _size,
        removeOnFinish: false);

    atualComponent = paradoComponent;
    add(paradoComponent);
  }

  void idle() {
    accelerationX = 0;
    isDucking = false;
  }

  void walkLeft() {
    accelerationX = -1;
  }

  void walkRight() {
    accelerationX = 1;
  }

  void duck() {
    isDucking = true;
  }

  void jump() {
    if (state == LucasState.salto || state == LucasState.cair) return;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -10);
    state = LucasState.salto;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = body.linearVelocity;

    if (velocity.y > 0.1) {
      state = LucasState.cair;
    } else if (velocity.y < 0.1 && state != LucasState.salto) {
      if (accelerationX != 0) {
        state = LucasState.caminhar;
      } else if (isDucking) {
        state = LucasState.duck;
      } else {
        state = LucasState.parado;
      }
    }

    velocity.x = accelerationX * 3;
    body.linearVelocity = velocity;

    if (state == LucasState.salto) {
      _setComponent(saltoComponent);
    } else if (state == LucasState.cair) {
      _setComponent(cairComponent);
    } else if (state == LucasState.caminhar) {
      _setComponent(caminharComponent);
    } else if (state == LucasState.duck) {
      _setComponent(duckComponent);
    } else if (state == LucasState.parado) {
      _setComponent(paradoComponent);
    }
  }

  void _setComponent(PositionComponent component) {
    if (accelerationX < 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else {
      if (component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    }

    if (component == atualComponent) return;
    remove(atualComponent);
    atualComponent = component;
    add(component);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(128, 128),
      type: BodyType.dynamic,
    );

    final shape = PolygonShape()..setAsBoxXY(_size.x / 2, .90);

    final fixtureDef = FixtureDef(shape)
      ..density = 15
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

}
