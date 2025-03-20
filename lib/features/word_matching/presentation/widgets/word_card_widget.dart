import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/word_pair.dart';

class WordCardWidget extends StatelessWidget {
  final WordPair wordPair;
  final bool isMatched;
  final bool showWord;
  final bool isTarget;
  final Function(WordPair)? onTap;

  const WordCardWidget({
    super.key,
    required this.wordPair,
    this.isMatched = false,
    this.showWord = false,
    this.isTarget = true, // default as target (image card)
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isMatched
              ? null
              : () {
                if (onTap != null) {
                  onTap!(wordPair);
                }
              },
      child: Container(
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isMatched)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
              ],
              border: Border.all(
                color: isMatched ? Colors.green : Colors.grey.shade300,
                width: isMatched ? 2 : 1,
              ),
            ),
            child: isTarget ? _buildTargetCard() : _buildWordCard(),
          )
          .animate()
          .scaleXY(
            begin: 0.9,
            end: 1.0,
            duration: 300.ms,
            curve: Curves.easeOutQuad,
          )
          .fadeIn(duration: 300.ms),
    );
  }

  Widget _buildTargetCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          // Image background
          Positioned.fill(
            child: Image.asset(
              wordPair.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 40),
                  ),
                );
              },
            ),
          ),

          // Meaning overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
              ),
              child: Text(
                wordPair.meaning,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Matched overlay
          if (isMatched)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          wordPair.word,
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Icon(
                        Icons.check_circle,
                        color: Colors.white.withValues(alpha: 0.9),
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          wordPair.word,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isMatched ? Colors.green.shade800 : Colors.orange.shade800,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isMatched) {
      return Colors.green.shade50;
    }
    return isTarget ? Colors.white : Colors.orange.shade100;
  }
}
