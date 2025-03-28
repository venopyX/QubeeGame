import 'package:flutter/material.dart';
import '../../domain/entities/qubee.dart';

/// A card widget displaying a Qubee letter with its status
///
/// Shows the letter with visual indicators for locked, unlocked,
/// or completed status, and additional details like accuracy.
class QubeeLetterCardWidget extends StatelessWidget {
  /// The Qubee letter to display
  final Qubee letter;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Creates a QubeeLetterCardWidget
  const QubeeLetterCardWidget({required this.letter, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLocked = !letter.isUnlocked;
    final bool isCompleted = letter.isCompleted;
    final bool isInProgress = letter.isUnlocked && !isCompleted;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color:
              isCompleted
                  ? Colors.green
                  : (isLocked ? Colors.grey[300]! : Colors.blue[300]!),
          width: isCompleted ? 2 : 1,
        ),
      ),
      color: isLocked ? Colors.grey[100] : Colors.white,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Letters - uppercase and lowercase side by side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        letter.letter, // Uppercase
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        letter.smallLetter, // Lowercase
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isLocked
                              ? Colors.grey[200]
                              : (isCompleted
                                  ? Colors.green[50]
                                  : Colors.orange[50]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isLocked
                          ? '${letter.requiredPoints} pts to unlock'
                          : (isCompleted ? 'Completed' : 'Available'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isLocked
                                ? Colors.grey[600]
                                : (isCompleted ? Colors.green : Colors.orange),
                      ),
                    ),
                  ),

                  // Accuracy display
                  if (isCompleted && letter.tracingAccuracy > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Accuracy: ${(letter.tracingAccuracy * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Practice count
                  if (letter.practiceCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Practiced: ${letter.practiceCount} ${letter.practiceCount == 1 ? 'time' : 'times'}',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Status icon
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color:
                      isLocked
                          ? Colors.grey[200]
                          : (isCompleted
                              ? Colors.green[100]
                              : Colors.blue[100]),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isLocked
                      ? Icons.lock
                      : (isCompleted ? Icons.check_circle : Icons.play_circle),
                  color:
                      isLocked
                          ? Colors.grey
                          : (isCompleted ? Colors.green : Colors.blue),
                  size: 20,
                ),
              ),
            ),

            // Progress indicator for letters in progress
            if (isInProgress && letter.tracingAccuracy > 0)
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: LinearProgressIndicator(
                  value: letter.tracingAccuracy,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
