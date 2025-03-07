import 'package:flutter/material.dart';
import '../../domain/entities/land.dart';

class LandCardWidget extends StatelessWidget {
  final Land land;
  final int completedLetters;
  final int totalLetters;
  final VoidCallback onTap;

  const LandCardWidget({
    required this.land,
    required this.completedLetters,
    required this.totalLetters,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Land image or placeholder
                Positioned.fill(
                  child: Image.asset(
                    land.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue[300]!,
                            Colors.blue[500]!,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Overlay for better text contrast
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Land info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                land.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                land.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Progress indicator
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: totalLetters > 0
                                      ? completedLetters / totalLetters
                                      : 0,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.amber[400]!,
                                  ),
                                  minHeight: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$completedLetters/$totalLetters letters mastered',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Lock indicator or arrow
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: land.isUnlocked
                                ? Colors.green.withOpacity(0.8)
                                : Colors.grey.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            land.isUnlocked
                                ? Icons.arrow_forward
                                : Icons.lock,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}