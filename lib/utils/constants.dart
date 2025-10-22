import 'dart:ui';

/// Game constants for TapDash
class GameConstants {
  // Player settings
  static const double playerSize = 30.0;
  static const double playerSpeed = 200.0; // pixels per second
  static const double playerVerticalSpeed = 150.0; // vertical movement speed
  
  // Obstacle settings
  static const double obstacleWidth = 40.0;
  static const double obstacleHeight = 40.0;
  static const double obstacleSpeed = 200.0; // pixels per second
  static const double minObstacleSpacing = 300.0;
  static const double maxObstacleSpacing = 500.0;
  static const double obstacleSpawnInterval = 1.5; // seconds
  
  // Game settings
  static const double gameWidth = 800.0;
  static const double gameHeight = 600.0;
  static const double groundLevel = 500.0;
  static const double ceilingLevel = 100.0;
  
  // Colors
  static const Color playerColor = Color(0xFF00FF00); // Green
  static const Color obstacleColor = Color(0xFFFF0000); // Red
  static const Color backgroundColor = Color(0xFF1A1A2E);
  static const Color groundColor = Color(0xFF16213E);
  static const Color textColor = Color(0xFFEEEEEE);
  
  // Physics
  static const double gravity = 0.0; // No gravity - manual control
}
