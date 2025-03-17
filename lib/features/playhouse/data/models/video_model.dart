import '../../domain/entities/video.dart';

class VideoModel extends Video {
  VideoModel({
    required super.id,
    required super.title,
    required super.thumbnailUrl,
    required super.videoId,
    required super.description,
    super.tags,
    super.category,
  });

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