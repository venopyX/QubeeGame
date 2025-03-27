import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_progress_indicator.dart';

/// A widget displaying user's achievement progress
class AchievementProgressCard extends StatelessWidget {
  /// Number of correct answers given by the user
  final int correctAnswers;

  /// Total number of answers needed for achievement
  final int targetAnswers;

  /// Whether the achievement has been unlocked
  final bool achievementUnlocked;

  /// Creates an achievement progress card
  const AchievementProgressCard({
    super.key,
    required this.correctAnswers,
    required this.targetAnswers,
    required this.achievementUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
              achievementUnlocked
                  ? Colors.amber
                  : Colors.grey.withValues(alpha: 0.3),
          width: achievementUnlocked ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                achievementUnlocked ? Icons.emoji_events : Icons.article,
                color:
                    achievementUnlocked ? Colors.amber[700] : Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                achievementUnlocked ? 'Achievement Unlocked!' : 'Word Mastery',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:
                      achievementUnlocked
                          ? Colors.amber[700]
                          : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GradientProgressIndicator(
            value: correctAnswers / targetAnswers,
            height: 8,
            startColor:
                achievementUnlocked ? Colors.amber[400]! : Colors.green[300]!,
            endColor:
                achievementUnlocked ? Colors.amber[700]! : Colors.green[500]!,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '$correctAnswers / $targetAnswers correct answers',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
