import 'package:flutter/material.dart';
import '../../domain/entities/playhouse_progress.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VillageProgressWidget extends StatelessWidget {
  final PlayhouseProgress progress;

  const VillageProgressWidget({
    super.key,  // Changed to super parameter
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2),  // Colors.blue[700]
            Color(0xFF42A5F5),  // Colors.blue[500]
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(77),  // Replaced withOpacity(0.3)
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Village Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 24,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${progress.starsCollected}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Village Level: ${progress.level}',
            style: TextStyle(
              color: Colors.white.withAlpha(230),  // Replaced withOpacity(0.9)
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Houses Unlocked: ${progress.unlockedVideos.length}',
            style: TextStyle(
              color: Colors.white.withAlpha(230),  // Replaced withOpacity(0.9)
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _calculateLevelProgress(),
            backgroundColor: Colors.white.withAlpha(77),  // Replaced withOpacity(0.3)
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            _getProgressText(),
            style: TextStyle(
              color: Colors.white.withAlpha(230),  // Replaced withOpacity(0.9)
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutQuad);
  }

  double _calculateLevelProgress() {
    final starsForNextLevel = progress.level * 5;
    final currentLevelMinStars = (progress.level - 1) * 5;
    final starsInCurrentLevel = progress.starsCollected - currentLevelMinStars;
    final levelProgressPercentage = starsInCurrentLevel / 5;
    return levelProgressPercentage.clamp(0.0, 1.0);
  }

  String _getProgressText() {
    final starsForNextLevel = progress.level * 5;
    return '${progress.starsCollected} / $starsForNextLevel stars to next level';
  }
}