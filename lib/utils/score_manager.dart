import 'package:flutter/foundation.dart';

/// Singleton ScoreManager to handle score tracking across the game
class ScoreManager extends ChangeNotifier {
  static final ScoreManager _instance = ScoreManager._internal();
  
  factory ScoreManager() {
    return _instance;
  }
  
  ScoreManager._internal();

  int _currentScore = 0;
  int _highScore = 0;
  double _distanceTraveled = 0.0;

  int get currentScore => _currentScore;
  int get highScore => _highScore;
  double get distanceTraveled => _distanceTraveled;

  /// Update score based on distance traveled
  void updateScore(double distance) {
    _distanceTraveled = distance;
    _currentScore = (distance / 10).floor(); // 1 point per 10 units
    
    if (_currentScore > _highScore) {
      _highScore = _currentScore;
    }
    
    notifyListeners();
  }

  /// Reset current score for new game
  void resetCurrentScore() {
    _currentScore = 0;
    _distanceTraveled = 0.0;
    notifyListeners();
  }

  /// Reset all scores (for testing)
  void resetAll() {
    _currentScore = 0;
    _highScore = 0;
    _distanceTraveled = 0.0;
    notifyListeners();
  }
}
