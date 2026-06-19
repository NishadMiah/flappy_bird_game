import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flappy_bird_game.dart';

class Background extends PositionComponent
    with HasGameReference<FlappyBirdGame> {
  double velocity = 60.0; // Scrolling velocity of the background features
  double cloudScrollOffset = 0.0;
  double cityScrollOffset = 0.0;

  // Cache random building widths and heights for consistency
  final List<double> _buildingWidths = [];
  final List<double> _buildingHeights = [];
  final List<Color> _buildingColors = [];
  final int _buildingCount = 30;

  Background() {
    // Generate random city skyline
    final random = Random();
    for (int i = 0; i < _buildingCount; i++) {
      _buildingWidths.add(60.0 + random.nextDouble() * 80.0);
      _buildingHeights.add(100.0 + random.nextDouble() * 200.0);
      // Variations of dark slate blue for depth
      final tone = 30 + random.nextInt(30);
      _buildingColors.add(Color.fromARGB(255, tone, tone + 10, tone + 25));
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Only scroll if game is active or in menu
    if (game.state != GameState.gameOver) {
      cloudScrollOffset = (cloudScrollOffset + (velocity * 0.3) * dt) % size.x;
      cityScrollOffset = (cityScrollOffset + (velocity * 0.6) * dt) % size.x;
    }
  }

  @override
  void render(Canvas canvas) {
    // 1. Draw Sky Gradient
    final skyRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1E88E5), // Rich sky blue
          const Color(0xFF90CAF9), // Soft light blue at horizon
        ],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // 2. Draw Clouds (Parallax Layer 1 - Slowest)
    _drawClouds(canvas);

    // 3. Draw City Skyline (Parallax Layer 2 - Medium Speed)
    _drawSkyline(canvas);
  }

  void _drawClouds(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    // Draw clouds repeated across the screen for seamless scrolling
    for (int i = 0; i < 2; i++) {
      final baseOffset = (i * size.x) - cloudScrollOffset;

      // Cloud 1
      canvas.drawCircle(
        Offset(baseOffset + size.x * 0.2, size.y * 0.15),
        35,
        paint,
      );
      canvas.drawCircle(
        Offset(baseOffset + size.x * 0.25, size.y * 0.13),
        45,
        paint,
      );
      canvas.drawCircle(
        Offset(baseOffset + size.x * 0.31, size.y * 0.15),
        35,
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          baseOffset + size.x * 0.2,
          size.y * 0.15 - 10,
          size.x * 0.11,
          45,
        ),
        paint,
      );

      // Cloud 2
      canvas.drawCircle(
        Offset(baseOffset + size.x * 0.7, size.y * 0.25),
        25,
        paint,
      );
      canvas.drawCircle(
        Offset(baseOffset + size.x * 0.74, size.y * 0.23),
        35,
        paint,
      );
      canvas.drawCircle(
        Offset(baseOffset + size.x * 0.79, size.y * 0.25),
        25,
        paint,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          baseOffset + size.x * 0.7,
          size.y * 0.25 - 5,
          size.x * 0.09,
          30,
        ),
        paint,
      );
    }
  }

  void _drawSkyline(Canvas canvas) {
    // Determine horizon line (bottom of playable area, just above ground)
    final horizonY = size.y - 110.0; // Assuming ground height is roughly 110.0

    double currentX1 = -cityScrollOffset;
    double currentX2 = size.x - cityScrollOffset;

    void drawSkylineSegment(double startX) {
      double x = startX;
      for (int i = 0; i < _buildingCount; i++) {
        final w = _buildingWidths[i];
        final h = _buildingHeights[i];

        final rect = Rect.fromLTWH(x, horizonY - h, w, h);
        final paint = Paint()
          ..color = _buildingColors[i].withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;

        canvas.drawRect(rect, paint);

        // Add minimal windows to buildings for detail
        final windowPaint = Paint()
          ..color = Colors.yellow.withValues(alpha: 0.15)
          ..style = PaintingStyle.fill;

        // Draw 2 columns of windows if wide enough
        if (w > 80) {
          for (double wy = horizonY - h + 20; wy < horizonY - 20; wy += 35) {
            canvas.drawRect(Rect.fromLTWH(x + 15, wy, 8, 12), windowPaint);
            canvas.drawRect(Rect.fromLTWH(x + w - 23, wy, 8, 12), windowPaint);
          }
        }

        x += w;
        if (x > startX + size.x + 100) break; // Break if past visible screen
      }
    }

    drawSkylineSegment(currentX1);
    drawSkylineSegment(currentX2);
  }
}
