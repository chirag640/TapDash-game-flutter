import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/score_manager.dart';
import 'components/obstacle.dart';
import 'components/player.dart';

/// Main game class for TapDash
class TapDashGame extends FlameGame
    with HasCollisionDetection, TapDetector {
  late Player player;
  late ScoreManager scoreManager;
  
  final Random _random = Random();
  double _nextObstacleSpawnX = 0.0;
  bool _isGameOver = false;
  
  final List<Obstacle> _obstacles = [];
  
  // FPS tracking
  final ValueNotifier<double> fps = ValueNotifier<double>(60.0);
  double _fpsUpdateTimer = 0.0;
  int _frameCount = 0;

  @override
  Color backgroundColor() => GameConstants.backgroundColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize score manager
    scoreManager = ScoreManager();

    // Initialize camera to fixed viewport
    camera.viewfinder.visibleGameSize = Vector2(
      GameConstants.gameWidth,
      GameConstants.gameHeight,
    );
    camera.viewfinder.anchor = Anchor.centerLeft;

    // Create player
    player = Player(
      position: Vector2(
        GameConstants.gameWidth * 0.2,
        GameConstants.gameHeight * 0.5,
      ),
    );
    await add(player);

    // Set initial obstacle spawn position
    _nextObstacleSpawnX = player.position.x + GameConstants.gameWidth;
    
    // Start the game
    _startGame();
  }

  /// Start a new game
  void _startGame() {
    _isGameOver = false;
    scoreManager.resetCurrentScore();
  }

  /// Handle game over
  void _gameOver() {
    if (_isGameOver) return;
    
    _isGameOver = true;
    player.die();
    
    // Game over will be handled, allowing restart
  }

  /// Restart the game instantly
  void restart() {
    // Clear all obstacles
    for (final obstacle in _obstacles) {
      obstacle.removeFromParent();
    }
    _obstacles.clear();

    // Reset player
    player.reset();

    // Reset camera
    camera.viewfinder.position = Vector2.zero();

    // Reset spawn position
    _nextObstacleSpawnX = player.position.x + GameConstants.gameWidth;

    // Start new game
    _startGame();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update FPS counter
    _updateFPS(dt);

    if (_isGameOver) return;

    // Update camera to follow player
    camera.viewfinder.position = Vector2(player.position.x, 0);

    // Update score based on distance
    scoreManager.updateScore(player.distanceTraveled);

    // Spawn obstacles
    _updateObstacleSpawning(dt);

    // Check for collisions
    _checkCollisions();

    // Clean up off-screen obstacles
    _cleanupObstacles();
  }

  /// Update FPS tracking
  void _updateFPS(double dt) {
    _frameCount++;
    _fpsUpdateTimer += dt;

    if (_fpsUpdateTimer >= 0.5) {
      fps.value = _frameCount / _fpsUpdateTimer;
      _frameCount = 0;
      _fpsUpdateTimer = 0.0;
    }
  }

  /// Update obstacle spawning logic
  void _updateObstacleSpawning(double dt) {
    // Spawn obstacle when player approaches the spawn point
    if (player.position.x >= _nextObstacleSpawnX - GameConstants.gameWidth) {
      _spawnObstacle();
      
      // Calculate next spawn position
      final spacing = GameConstants.minObstacleSpacing +
          _random.nextDouble() * (GameConstants.maxObstacleSpacing - GameConstants.minObstacleSpacing);
      _nextObstacleSpawnX += spacing;
    }
  }

  /// Spawn a new obstacle
  void _spawnObstacle() {
    // Random Y position between ceiling and ground
    final minY = GameConstants.ceilingLevel + GameConstants.obstacleHeight;
    final maxY = GameConstants.groundLevel - GameConstants.obstacleHeight;
    final randomY = minY + _random.nextDouble() * (maxY - minY);

    final obstacle = Obstacle(
      position: Vector2(_nextObstacleSpawnX, randomY),
    );

    add(obstacle);
    _obstacles.add(obstacle);
  }

  /// Check for collisions between player and obstacles
  void _checkCollisions() {
    for (final obstacle in _obstacles) {
      if (_checkCollisionBetween(player, obstacle)) {
        _gameOver();
        return;
      }
    }
  }

  /// Check collision between two components using AABB
  bool _checkCollisionBetween(PositionComponent a, PositionComponent b) {
    final aRect = a.toRect();
    final bRect = b.toRect();
    return aRect.overlaps(bRect);
  }

  /// Clean up obstacles that are off-screen
  void _cleanupObstacles() {
    _obstacles.removeWhere((obstacle) {
      if (obstacle.position.x < player.position.x - GameConstants.gameWidth) {
        obstacle.removeFromParent();
        return true;
      }
      return false;
    });
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    if (_isGameOver) {
      // Restart on tap after game over
      restart();
    } else {
      // Flip player direction during gameplay
      player.flip();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw ground line
    final groundPaint = Paint()
      ..color = GameConstants.groundColor
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        GameConstants.groundLevel,
        size.x,
        size.y - GameConstants.groundLevel,
      ),
      groundPaint,
    );

    // Draw ceiling line
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.x,
        GameConstants.ceilingLevel,
      ),
      groundPaint,
    );
  }
}
