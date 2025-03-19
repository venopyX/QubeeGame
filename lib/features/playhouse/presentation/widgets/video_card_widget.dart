import 'package:flutter/material.dart';
import '../../domain/entities/video.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VideoCardWidget extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;

  const VideoCardWidget({
    super.key,
    required this.video,
    required this.onTap,
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
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  video.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Title and tags
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (video.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(video.category!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        video.category!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      for (final tag in video.tags.take(2))
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Chip(
                            label: Text(tag),
                            labelStyle: TextStyle(fontSize: 10),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutQuad),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'basics':
        return Colors.blue;
      case 'stories':
        return Colors.purple;
      case 'vocabulary':
        return Colors.green;
      case 'culture':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}