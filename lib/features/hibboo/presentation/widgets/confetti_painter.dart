import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom painter for drawing confetti animation
class ConfettiPainter extends CustomPainter {
  /// Animation controller for the confetti effect
  final AnimationController controller;
  
  /// Random number generator for confetti placement
  final math.Random random = math.Random();
  
  /// Number of confetti particles to draw
  final int particleCount;

  /// Creates a confetti painter
  ConfettiPainter({
    required this.controller, 
    this.particleCount = 50,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    for (var i = 0; i < particleCount; i++) {
      final paint = Paint()
        ..color = colors[random.nextInt(colors.length)]
        ..style = PaintingStyle.fill;
        
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * (controller.value);
      
      // Draw various shapes for confetti
      switch (i % 3) {
        case 0:
          // Circle
          canvas.drawCircle(Offset(x, y), 4, paint);
          break;
        case 1:
          // Square
          canvas.drawRect(
            Rect.fromCenter(center: Offset(x, y), width: 8, height: 8),
            paint,
          );
          break;
        case 2:
          // Triangle
          final path = Path();
          path.moveTo(x, y - 4);
          path.lineTo(x + 4, y + 4);
          path.lineTo(x - 4, y + 4);
          path.close();
          canvas.drawPath(path, paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}