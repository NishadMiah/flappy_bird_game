import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flappy_bird_game.dart';

class Ground extends PositionComponent with HasGameReference<FlappyBirdGame> {
  double velocity = 120.0; // Scrolling velocity of the ground
  double scrollOffset = 0.0;
  final double groundHeight = 110.0;

  @override
  Future<void> onLoad() async {
    // Ground is located at the bottom of the screen
    size = Vector2(game.size.x, groundHeight);
    position = Vector2(0.0, game.size.y - groundHeight);

    // Add rectangle hitbox for collision detection
    add(RectangleHitbox(position: Vector2.zero(), size: size));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = Vector2(size.x, groundHeight);
    position = Vector2(0.0, size.y - groundHeight);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Only scroll if game is active or in menu
    if (game.state != GameState.gameOver) {
      scrollOffset =
          (scrollOffset + velocity * dt) % 30.0; // Loop offset every 30px
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    // 1. Draw soil base (brown)
    final soilPaint = Paint()
      ..color =
          const Color(0xFFD7CCC8) // Soft warm brown/beige
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, soilPaint);

    // 2. Draw grass top (vibrant green)
    final grassHeight = 16.0;
    final grassPaint = Paint()
      ..color =
          const Color(0xFF4CAF50) // Vibrant grass green
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, grassHeight), grassPaint);

    // 3. Draw grass border (darker green line)
    final borderPaint = Paint()
      ..color =
          const Color(0xFF388E3C) // Darker green
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, grassHeight),
      Offset(size.x, grassHeight),
      borderPaint,
    );

    // 4. Draw moving stripes in the soil for a sense of speed
    final stripePaint = Paint()
      ..color = const Color(0xFFBCAAA4).withValues(alpha: 0.5)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final double stripeSpacing = 30.0;
    final double startX = -scrollOffset;

    // Draw diagonal lines across the soil block
    for (double x = startX; x < size.x + 30.0; x += stripeSpacing) {
      canvas.drawLine(
        Offset(x, grassHeight + 4.0),
        Offset(x - 15.0, size.y),
        stripePaint,
      );
    }
  }
}
