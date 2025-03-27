import 'package:flutter/material.dart';

/// A custom progress indicator with gradient coloring
class GradientProgressIndicator extends StatelessWidget {
  /// Current progress value (0.0 to 1.0)
  final double value;

  /// Background color of the progress bar
  final Color backgroundColor;

  /// Start color of the progress gradient
  final Color startColor;

  /// End color of the progress gradient
  final Color endColor;

  /// Height of the progress bar
  final double height;

  /// Border radius of the progress bar
  final double borderRadius;

  /// Creates a gradient progress indicator
  const GradientProgressIndicator({
    super.key,
    required this.value,
    this.backgroundColor = const Color(0xFFEEEEEE),
    required this.startColor,
    required this.endColor,
    this.height = 8.0,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        // Progress indicator
        FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [startColor, endColor]),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ],
    );
  }
}
