import 'package:flutter/material.dart';
import '../../domain/entities/treasure.dart';

class TreasureCollectionWidget extends StatelessWidget {
  final List<Treasure> treasures;

  const TreasureCollectionWidget({
    required this.treasures,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: treasures.length,
      itemBuilder: (context, index) {
        final treasure = treasures[index];
        return _buildTreasureCard(context, treasure);
      },
    );
  }

  Widget _buildTreasureCard(BuildContext context, Treasure treasure) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.amber[100]!,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Treasure icon or image
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              treasure.imagePath,
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.emoji_events,
                size: 36,
                color: Colors.amber[700],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Word
          Text(
            treasure.word,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Meaning
          Text(
            treasure.meaning,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}