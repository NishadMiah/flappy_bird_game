import 'package:flutter/material.dart';
import '../flappy_bird_game.dart';

class HUD extends StatelessWidget {
  final FlappyBirdGame game;

  const HUD({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ValueListenableBuilder<int>(
            valueListenable: game.scoreNotifier,
            builder: (context, score, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  '$score',
                  key: ValueKey<int>(score),
                  style: const TextStyle(
                    fontSize: 48.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 6.0,
                        color: Colors.black45,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
