import 'package:flutter/material.dart';
import '../../domain/entities/qubee.dart';

class QubeeLetterCardWidget extends StatelessWidget {
  final Qubee letter;
  final VoidCallback? onTap;
  
  const QubeeLetterCardWidget({
    required this.letter,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLocked = !letter.isUnlocked;
    final bool isCompleted = letter.isCompleted;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCompleted 
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
                  Text(
                    isLocked 
                        ? 'Locked (${letter.requiredPoints} pts)'
                        : (isCompleted ? 'Completed' : 'Available'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isLocked 
                          ? Colors.grey[600]
                          : (isCompleted ? Colors.green : Colors.orange),
                    ),
                  ),
                  
                  // Accuracy
                  if (isCompleted && letter.tracingAccuracy > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Accuracy: ${(letter.tracingAccuracy * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[700],
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
              child: Icon(
                isLocked 
                    ? Icons.lock
                    : (isCompleted ? Icons.check_circle : Icons.play_circle),
                color: isLocked 
                    ? Colors.grey
                    : (isCompleted ? Colors.green : Colors.blue),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}