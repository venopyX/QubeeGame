import 'package:flutter/material.dart';

/// Dialog for selecting game difficulty level
class DifficultyDialog extends StatelessWidget {
  /// Callback when a difficulty is selected
  final Function(int) onDifficultySelected;

  /// Creates a DifficultyDialog
  const DifficultyDialog({super.key, required this.onDifficultySelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Difficulty'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDifficultyOption(
            context,
            difficulty: 4,
            name: 'Easy',
            description: '4 word pairs',
          ),
          const SizedBox(height: 12),
          _buildDifficultyOption(
            context,
            difficulty: 6,
            name: 'Medium',
            description: '6 word pairs',
          ),
          const SizedBox(height: 12),
          _buildDifficultyOption(
            context,
            difficulty: 8,
            name: 'Hard',
            description: '8 word pairs',
          ),
        ],
      ),
    );
  }

  /// Builds a difficulty option button
  Widget _buildDifficultyOption(
    BuildContext context, {
    required int difficulty,
    required String name,
    required String description,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onDifficultySelected(difficulty);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$difficulty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
