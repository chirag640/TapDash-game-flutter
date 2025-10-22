import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Obstacle component that moves towards the player
class Obstacle extends PositionComponent {
  Obstacle({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2(
            GameConstants.obstacleWidth,
            GameConstants.obstacleHeight,
          ),
          anchor: Anchor.center,
        );

  bool _isOffScreen = false;

  bool get isOffScreen => _isOffScreen;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add collision detection
    add(RectangleHitbox(
      size: size,
      anchor: Anchor.center,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move obstacle to the left (relative to world)
    // Since camera follows player, obstacles appear stationary in world space
    // We don't move them here - they're positioned in world coordinates
    
    // Check if obstacle is off screen (behind the camera)
    if (position.x < -100) {
      _isOffScreen = true;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw obstacle as a simple red square
    final paint = Paint()
      ..color = GameConstants.obstacleColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: size.x,
        height: size.y,
      ),
      paint,
    );
  }
}
