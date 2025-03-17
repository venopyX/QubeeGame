class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String videoId; // YouTube video ID
  final String description;
  final List<String> tags;
  final String? category;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
    required this.description,
    this.tags = const [],
    this.category,
  });
}