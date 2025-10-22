import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

/// Direction enum for player movement
enum Direction {
  up,
  down,
}

/// Player component with tap-to-flip mechanic
class Player extends PositionComponent with CollisionCallbacks {
  Player({
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(GameConstants.playerSize),
          anchor: Anchor.center,
        );

  Direction _direction = Direction.down;
  double _distanceTraveled = 0.0;
  bool _isAlive = true;

  Direction get direction => _direction;
  double get distanceTraveled => _distanceTraveled;
  bool get isAlive => _isAlive;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add collision detection
    add(RectangleHitbox(
      size: size,
      anchor: Anchor.center,
    ));
  }

  /// Flip the player's direction
  void flip() {
    if (!_isAlive) return;
    
    if (_direction == Direction.up) {
      _direction = Direction.down;
    } else {
      _direction = Direction.up;
    }
  }

  /// Reset player state for new game
  void reset() {
    _direction = Direction.down;
    _distanceTraveled = 0.0;
    _isAlive = true;
    position = Vector2(
      GameConstants.gameWidth * 0.2,
      GameConstants.gameHeight * 0.5,
    );
  }

  /// Kill the player (for game over)
  void die() {
    _isAlive = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isAlive) return;

    // Move forward continuously
    position.x += GameConstants.playerSpeed * dt;
    _distanceTraveled += GameConstants.playerSpeed * dt;

    // Move vertically based on direction
    if (_direction == Direction.up) {
      position.y -= GameConstants.playerVerticalSpeed * dt;
    } else {
      position.y += GameConstants.playerVerticalSpeed * dt;
    }

    // Boundary check - prevent going off screen
    if (position.y < GameConstants.ceilingLevel + size.y / 2) {
      position.y = GameConstants.ceilingLevel + size.y / 2;
      _direction = Direction.down; // Auto-flip at ceiling
    }
    
    if (position.y > GameConstants.groundLevel - size.y / 2) {
      position.y = GameConstants.groundLevel - size.y / 2;
      _direction = Direction.up; // Auto-flip at ground
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw player as a simple square
    final paint = Paint()
      ..color = GameConstants.playerColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y / 2),
        width: size.x,
        height: size.y,
      ),
      paint,
    );

    // Draw direction indicator
    final indicatorPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final indicatorY = _direction == Direction.up ? size.y * 0.25 : size.y * 0.75;
    canvas.drawCircle(
      Offset(size.x / 2, indicatorY),
      3,
      indicatorPaint,
    );
  }
}
