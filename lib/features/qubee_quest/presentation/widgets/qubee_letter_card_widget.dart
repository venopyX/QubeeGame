import 'package:flutter/material.dart';
import '../../domain/entities/qubee.dart';

class QubeeLetterCardWidget extends StatelessWidget {
  final Qubee letter;
  final VoidCallback onTap;

  const QubeeLetterCardWidget({
    required this.letter,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: letter.isCompleted
              ? Border.all(color: Colors.green, width: 3)
              : null,
        ),
        child: Stack(
          children: [
            // Letter display
            Center(
              child: Text(
                letter.letter,
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: letter.isUnlocked
                      ? Colors.black87
                      : Colors.grey[400],
                ),
              ),
            ),

            // Lock icon for locked letters
            if (!letter.isUnlocked)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),

            // Completion indicator
            if (letter.isCompleted)
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}