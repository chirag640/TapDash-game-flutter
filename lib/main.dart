import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/tap_dash_game.dart';
import 'ui/game_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations and system UI
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  runApp(const TapDashApp());
}

class TapDashApp extends StatelessWidget {
  const TapDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TapDash',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        fontFamily: 'monospace',
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final TapDashGame game;

  @override
  void initState() {
    super.initState();
    game = TapDashGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game widget
          GameWidget(
            game: game,
          ),
          // Overlay UI
          GameOverlay(game: game),
        ],
      ),
    );
  }
}

