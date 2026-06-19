import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../flappy_bird_game.dart';
import 'ground.dart';
import 'pipe.dart';

class Bird extends PositionComponent with HasGameReference<FlappyBirdGame>, CollisionCallbacks {
  double velocity = 0.0;
  final double gravity = 1000.0;
  final double jumpStrength = -320.0;
  final double birdSize = 44.0;
  
  // Animation properties
  double wingAngle = 0.0;
  double wingDirection = 1.0;

  @override
  Future<void> onLoad() async {
    size = Vector2(birdSize, birdSize);
    // Anchor center so rotation happens around the center of the bird
    anchor = Anchor.center;
    
    // Position bird at 25% of screen width and center vertically
    reset();

    // Add circular hitbox for collision detection
    // Slightly smaller than visual size to be more forgiving to the player
    add(CircleHitbox(
      radius: (birdSize / 2) - 4,
      position: Vector2(4, 4),
    ));
  }

  void reset() {
    position = Vector2(game.size.x * 0.25, game.size.y / 2);
    velocity = 0.0;
    angle = 0.0;
  }

  void flap() {
    velocity = jumpStrength;
    angle = -0.3; // Tilt slightly up on jump
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (game.state == GameState.playing) {
      // 1. Apply gravity
      velocity += gravity * dt;
      position.y += velocity * dt;

      // 2. Handle rotation based on velocity (tilt)
      // Tilt down when falling, tilt up when jumping
      if (velocity < 0) {
        angle = max(-0.4, velocity / 1000.0);
      } else {
        angle = min(1.2, angle + dt * 2.0); // Fall tilt speed
      }

      // 3. Animate wing flapping
      wingAngle += wingDirection * 15.0 * dt;
      if (wingAngle.abs() > 0.4) {
        wingDirection *= -1;
      }
    } else if (game.state == GameState.mainMenu) {
      // Idle floating animation on main menu
      position.y = (game.size.y / 2) + sin(DateTime.now().millisecondsSinceEpoch / 200.0) * 10.0;
      angle = 0.0;
      wingAngle = 0.0;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    
    // Only collide with Pipes and Ground
    if (other is Pipe || other is Ground) {
      if (game.state == GameState.playing) {
        game.gameOver();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Canvas coordinate system is relative to this component's top-left,
    // but since we anchored to Center, the center is at (width/2, height/2).
    final centerX = size.x / 2;
    final centerY = size.y / 2;
    final radius = size.x / 2;

    // 1. Draw Bird Body (Vibrant Yellow Circle)
    // Draw shadow/highlight gradient on body for depth
    final bodyRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF176), // Light yellow center
          const Color(0xFFFBC02D), // Darker gold edge
        ],
        center: const Alignment(-0.2, -0.2),
      ).createShader(bodyRect);
    canvas.drawCircle(Offset(centerX, centerY), radius, gradientPaint);

    // Outline body
    final bodyOutline = Paint()
      ..color = const Color(0xFF5D4037) // Dark brown outline
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(centerX, centerY), radius, bodyOutline);

    // 2. Draw Beak (Vibrant Orange Triangle pointing right)
    final beakPaint = Paint()
      ..color = const Color(0xFFFF5722) // Deep Orange
      ..style = PaintingStyle.fill;
    final beakPath = Path()
      ..moveTo(centerX + radius - 4, centerY - 6)
      ..lineTo(centerX + radius + 12, centerY)
      ..lineTo(centerX + radius - 4, centerY + 6)
      ..close();
    canvas.drawPath(beakPath, beakPaint);
    canvas.drawPath(beakPath, bodyOutline);

    // 3. Draw Eye (Large White Circle with Black Pupil)
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX + 6, centerY - 8), 7, eyePaint);
    canvas.drawCircle(Offset(centerX + 6, centerY - 8), 7, bodyOutline);

    final pupilPaint = Paint()
      ..color = const Color(0xFF212121)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX + 8, centerY - 8), 3, pupilPaint);

    // 4. Draw Wing (White/Yellow Oval with flap rotation)
    canvas.save();
    // Translate to wing pivot point
    canvas.translate(centerX - 8, centerY + 2);
    canvas.rotate(wingAngle);
    
    final wingPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white,
          const Color(0xFFFFF59D), // Pale yellow
        ],
      ).createShader(const Rect.fromLTWH(-16, -10, 22, 16));

    final wingPath = Path()
      ..addOval(const Rect.fromLTWH(-16, -10, 22, 16));
    canvas.drawPath(wingPath, wingPaint);
    canvas.drawPath(wingPath, bodyOutline);
    canvas.restore();
  }
}
