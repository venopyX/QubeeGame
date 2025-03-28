import 'package:flutter/material.dart';

/// A rounded badge widget for displaying labels or status indicators
class RoundedBadge extends StatelessWidget {
  /// Text to display in the badge
  final String text;

  /// Background color of the badge
  final Color backgroundColor;

  /// Text color of the badge
  final Color textColor;

  /// Icon to display before the text (optional)
  final IconData? icon;

  /// Size of the icon if provided
  final double iconSize;

  /// Font weight for the badge text
  final FontWeight fontWeight;

  /// Font size of the text
  final double fontSize;

  /// Horizontal padding of the badge
  final double horizontalPadding;

  /// Vertical padding of the badge
  final double verticalPadding;

  /// Border radius of the badge
  final double borderRadius;

  /// Creates a rounded badge
  const RoundedBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.textColor = Colors.white,
    this.icon,
    this.iconSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 14.0,
    this.horizontalPadding = 12.0,
    this.verticalPadding = 6.0,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor, size: iconSize),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
