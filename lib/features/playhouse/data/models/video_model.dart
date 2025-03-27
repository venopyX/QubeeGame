import '../../domain/entities/video.dart';

/// Data model for video information, extending the base Video entity
class VideoModel extends Video {
  /// Creates a new VideoModel with the specified properties
  const VideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.videoId,
    required super.description,
    super.tags,
    super.category,
  });

  /// Creates a VideoModel from a JSON map
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoId: json['videoId'] as String,
      description: json['description'] as String,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList() ?? [],
      category: json['category'] as String?,
    );
  }

  /// Converts this VideoModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'videoId': videoId,
      'description': description,
      'tags': tags,
      'category': category,
    };
  }
}
