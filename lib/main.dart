import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game/flappy_bird_game.dart';
import 'game/overlays/game_over.dart';
import 'game/overlays/hud.dart';
import 'game/overlays/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set orientation to portrait only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set fullscreen mode for a more immersive game feel
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird Flame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        body: GameWidget<FlappyBirdGame>(
          game: FlappyBirdGame(),
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenu(game: game),
            'GameOver': (context, game) => GameOver(game: game),
            'HUD': (context, game) => HUD(game: game),
          },
        ),
      ),
    );
  }
}
