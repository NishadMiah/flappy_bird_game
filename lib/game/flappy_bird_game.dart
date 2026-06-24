import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'components/background.dart';
import 'components/bird.dart';
import 'components/ground.dart';
import 'components/pipe.dart';

enum GameState { mainMenu, playing, gameOver }

class FlappyBirdGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  final Random _random = Random();
  late Bird bird;
  late Ground ground;
  late Background background;
  
  GameState state = GameState.mainMenu;
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  int get score => scoreNotifier.value;
  set score(int value) => scoreNotifier.value = value;
  int highScore = 0;

  double pipeSpawnTimer = 0.0;
  final double pipeSpawnInterval = 1.8; // Spawn a pipe pair every 1.8 seconds

  @override
  Future<void> onLoad() async {
    // Add background first
    background = Background();
    await add(background);

    // Add ground
    ground = Ground();
    await add(ground);

    // Add bird
    bird = Bird();
    await add(bird);

    // Reset game state to main menu on load
    resetGame();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (state == GameState.playing) {
      // Spawn pipes at intervals
      pipeSpawnTimer += dt;
      if (pipeSpawnTimer >= pipeSpawnInterval) {
        spawnPipePair();
        pipeSpawnTimer = 0.0;
      }
    }
  }

  void spawnPipePair() {
    // Generate pipe pairs with a randomized vertical offset
    // The screen height determines our boundaries
    final screenHeight = size.y;
    final groundHeight = ground.size.y;
    final playableHeight = screenHeight - groundHeight;

    // Minimum distance from top and bottom boundaries for the gap
    const minPadding = 80.0;
    const gapSize = 180.0; // The spacing between top and bottom pipe

    final maxOffset = playableHeight - gapSize - (minPadding * 2);
    // Random height for the top pipe
    final randomOffset = minPadding + (maxOffset.isNaN || maxOffset <= 0 ? 0.0 : _random.nextDouble() * maxOffset);

    final topPipeY = randomOffset;
    final bottomPipeY = randomOffset + gapSize;

    // Add top pipe (pointing down)
    add(Pipe(
      isTop: true,
      pipeHeight: topPipeY,
      positionY: 0.0,
    ));

    // Add bottom pipe (pointing up)
    add(Pipe(
      isTop: false,
      pipeHeight: playableHeight - bottomPipeY,
      positionY: bottomPipeY,
    ));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    if (state == GameState.playing) {
      bird.flap();
    } else if (state == GameState.mainMenu) {
      startGame();
    }
  }

  void startGame() {
    state = GameState.playing;
    overlays.remove('MainMenu');
    overlays.add('HUD');
    bird.reset();
    
    // Remove existing pipes
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    pipeSpawnTimer = 0.0;
  }

  void gameOver() {
    state = GameState.gameOver;
    if (score > highScore) {
      highScore = score;
    }
    overlays.remove('HUD');
    overlays.add('GameOver');
    // Stop scrolling background and ground
    background.velocity = 0;
    ground.velocity = 0;
  }

  void resetGame() {
    state = GameState.mainMenu;
    score = 0;
    
    // Remove existing pipes
    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());
    
    bird.reset();
    background.velocity = 60.0; // Reset scroll speed
    ground.velocity = 120.0;

    overlays.remove('GameOver');
    overlays.remove('HUD');
    overlays.add('MainMenu');
  }

  void incrementScore() {
    score++;
  }
}
