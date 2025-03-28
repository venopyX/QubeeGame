import 'package:flutter/material.dart';

/// A card with gradient background and optional badge labels
///
/// This widget is used throughout the app for featured items
/// with consistent styling and animation-ready structure.
class AppGradientCard extends StatelessWidget {
  /// The title text displayed on the card
  final String title;

  /// A short description of the card content
  final String description;

  /// The starting gradient color
  final Color color1;

  /// The ending gradient color
  final Color color2;

  /// Icon to display on the card
  final IconData iconData;

  /// Function to call when the card is tapped
  final VoidCallback? onTap;

  /// Whether to show a "featured" badge
  final bool isFeatured;

  /// Whether to show a "new" badge
  final bool isNew;

  /// Whether to show the "Play Now" button
  final bool showPlayNow;

  const AppGradientCard({
    super.key,
    required this.title,
    required this.description,
    required this.color1,
    required this.color2,
    required this.iconData,
    this.onTap,
    this.isFeatured = false,
    this.isNew = false,
    this.showPlayNow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color1, color2],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color1.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                iconData,
                size: 160,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isNew) ...[
                        if (isFeatured) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'NEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(),
                  if (showPlayNow)
                    Row(
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Play Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
