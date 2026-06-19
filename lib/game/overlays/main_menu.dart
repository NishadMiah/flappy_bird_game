import 'dart:ui';
import 'package:flutter/material.dart';
import '../flappy_bird_game.dart';

class MainMenu extends StatefulWidget {
  final FlappyBirdGame game;

  const MainMenu({super.key, required this.game});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 30.0,
              ),
              width: 320.0,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 16.0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Game Logo Title
                  Text(
                    'FLAPPY BIRD PRO',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'FLAME ENGINE EDITION',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent.shade100,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40.0),

                  // Pulsing Play Button
                  GestureDetector(
                    onTap: widget.game.startGame,
                    child: ScaleTransition(
                      scale: _animation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36.0,
                          vertical: 16.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800), // Vibrant orange
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFF9800,
                              ).withValues(alpha: 0.5),
                              blurRadius: 12.0,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 28.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'PLAY NOW',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40.0),

                  // High Score Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      'HIGH SCORE: ${widget.game.highScore}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
