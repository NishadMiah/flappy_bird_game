import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flappy_bird_game.dart';

class Pipe extends PositionComponent with HasGameReference<FlappyBirdGame> {
  final bool isTop;
  final double pipeHeight;
  final double positionY;
  final double pipeWidth = 72.0;
  final double capHeight = 32.0;

  bool scored = false;

  Pipe({
    required this.isTop,
    required this.pipeHeight,
    required this.positionY,
  });

  @override
  Future<void> onLoad() async {
    size = Vector2(pipeWidth, pipeHeight);
    // Start at the right edge of the screen
    position = Vector2(game.size.x, positionY);

    // Add rectangle hitbox for collision detection
    add(RectangleHitbox(
      position: Vector2.zero(),
      size: size,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state == GameState.playing) {
      // 1. Move left
      position.x -= game.ground.velocity * dt;

      // 2. Score check: If bird passes the pipe (only do this for one pipe in the pair, e.g., the top one)
      if (isTop && !scored && position.x + (pipeWidth / 2) < game.bird.position.x) {
        scored = true;
        game.incrementScore();
      }

      // 3. Remove if it goes off screen
      if (position.x < -pipeWidth) {
        removeFromParent();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final darkOutlinePaint = Paint()
      ..color = const Color(0xFF3E2723) // Dark brown outline
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // 1. Set up linear gradient for 3D cylinder effect
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        const Color(0xFF66BB6A), // Light green (highlight)
        const Color(0xFF4CAF50), // Normal green
        const Color(0xFF2E7D32), // Dark green (shadow)
      ],
      stops: const [0.15, 0.45, 0.9],
    );

    final pipeBodyPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    // 2. Draw Pipe Body & Cap depending on top or bottom
    if (isTop) {
      // Body rect (excluding cap at bottom)
      final bodyRect = Rect.fromLTWH(4.0, 0, size.x - 8.0, size.y - capHeight);
      canvas.drawRect(bodyRect, pipeBodyPaint);
      canvas.drawRect(bodyRect, darkOutlinePaint);

      // Cap rect (at bottom of pipe)
      final capRect = Rect.fromLTWH(0, size.y - capHeight, size.x, capHeight);
      final capPaint = Paint()
        ..shader = gradient.createShader(capRect)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(capRect, const Radius.circular(4.0)),
        capPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(capRect, const Radius.circular(4.0)),
        darkOutlinePaint,
      );
    } else {
      // Body rect (excluding cap at top)
      final bodyRect = Rect.fromLTWH(4.0, capHeight, size.x - 8.0, size.y - capHeight);
      canvas.drawRect(bodyRect, pipeBodyPaint);
      canvas.drawRect(bodyRect, darkOutlinePaint);

      // Cap rect (at top of pipe)
      final capRect = Rect.fromLTWH(0, 0, size.x, capHeight);
      final capPaint = Paint()
        ..shader = gradient.createShader(capRect)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(capRect, const Radius.circular(4.0)),
        capPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(capRect, const Radius.circular(4.0)),
        darkOutlinePaint,
      );
    }
  }
}
