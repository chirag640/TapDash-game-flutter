import 'package:flutter/material.dart';
import '../game/tap_dash_game.dart';
import '../utils/constants.dart';
import '../utils/score_manager.dart';

/// Game overlay UI showing score and game over state
class GameOverlay extends StatefulWidget {
  final TapDashGame game;

  const GameOverlay({
    required this.game,
    super.key,
  });

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  late ScoreManager _scoreManager;

  @override
  void initState() {
    super.initState();
    _scoreManager = ScoreManager();
    _scoreManager.addListener(_onScoreUpdate);
  }

  @override
  void dispose() {
    _scoreManager.removeListener(_onScoreUpdate);
    super.dispose();
  }

  void _onScoreUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGameOver = !widget.game.player.isAlive;

    return Stack(
      children: [
        // Score display (top center)
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                'SCORE: ${_scoreManager.currentScore}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: GameConstants.textColor,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'HIGH: ${_scoreManager.highScore}',
                style: const TextStyle(
                  fontSize: 16,
                  color: GameConstants.textColor,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Instructions (bottom center) - only show during gameplay
        if (!isGameOver)
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'TAP TO FLIP DIRECTION',
                style: TextStyle(
                  fontSize: 18,
                  color: GameConstants.textColor,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Game Over overlay
        if (isGameOver)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'GAME OVER',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Score: ${_scoreManager.currentScore}',
                    style: const TextStyle(
                      fontSize: 32,
                      color: GameConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Best: ${_scoreManager.highScore}',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.yellowAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'TAP TO RESTART',
                    style: TextStyle(
                      fontSize: 24,
                      color: GameConstants.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.touch_app,
                    size: 48,
                    color: GameConstants.playerColor,
                  ),
                ],
              ),
            ),
          ),

        // FPS counter (top right) - for development
        Positioned(
          top: 20,
          right: 20,
          child: ValueListenableBuilder<double>(
            valueListenable: widget.game.fps,
            builder: (context, fps, child) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'FPS: ${fps.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: fps >= 55 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
