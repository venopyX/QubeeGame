import 'package:flutter/material.dart';

/// Entity class representing a game in the app
class GameInfo {
  /// Title of the game
  final String title;

  /// Short description of the game
  final String description;

  /// Icon representing the game
  final IconData icon;

  /// Primary color associated with the game
  final Color color;

  /// Whether the game is coming soon
  final bool comingSoon;

  /// Route name for navigation to the game
  final String? routeName;

  /// Creates a new GameInfo instance
  GameInfo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.comingSoon = false,
    this.routeName,
  });
}
