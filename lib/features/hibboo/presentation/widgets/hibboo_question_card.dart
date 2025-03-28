import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Card displaying a Hibboo riddle question
class HibbooQuestionCard extends StatelessWidget {
  /// The text of the riddle question
  final String questionText;

  /// Creates a question card with the provided riddle text
  const HibbooQuestionCard({super.key, required this.questionText});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.question_mark, size: 40, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              questionText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.brown[800],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
  }
}
