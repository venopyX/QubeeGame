import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A view displayed when the game is completed
class CompletionView extends StatelessWidget {
  /// Total score achieved
  final int score;

  /// Total number of questions in the game
  final int totalQuestions;

  /// Overall game statistics
  final Map<String, dynamic> stats;

  /// Callback for starting a new game with the same difficulty
  final VoidCallback onPlayNext;

  /// Callback for replaying the same game
  final VoidCallback onReplay;

  /// Callback for returning to category selection
  final VoidCallback onChooseCategory;

  /// Creates a CompletionView
  const CompletionView({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.stats,
    required this.onPlayNext,
    required this.onReplay,
    required this.onChooseCategory,
  });

  @override
  Widget build(BuildContext context) {
    final gamesPlayed = stats['gamesPlayed'] ?? 0;
    final highestScore = stats['highestScore'] ?? 0;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 80,
            ).animate().scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
            const SizedBox(height: 24),
            Text(
              'Game Completed!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
            const SizedBox(height: 16),
            Text(
              'You matched $score/$totalQuestions words correctly',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

            const SizedBox(height: 24),

            // Stats display
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Stats',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Games Played:',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Text(
                        '$gamesPlayed',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Highest Score:',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      Text(
                        '$highestScore',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 700.ms, duration: 500.ms),

            const SizedBox(height: 32),

            // Action buttons
            Column(
              children: [
                // Play Next Game button - prominent
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Play Next Game'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onPlayNext,
                ),
                const SizedBox(height: 16),

                // Replay Same Game button
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay),
                  label: const Text('Replay Same Words'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: onReplay,
                ),
                const SizedBox(height: 16),

                // Choose Category button
                TextButton.icon(
                  icon: Icon(Icons.category, color: Colors.purple.shade700),
                  label: Text(
                    'Choose Different Category',
                    style: TextStyle(
                      color: Colors.purple.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: onChooseCategory,
                ),
              ],
            ).animate().fadeIn(delay: 800.ms, duration: 500.ms),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
