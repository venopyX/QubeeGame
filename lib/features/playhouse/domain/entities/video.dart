/// Entity representing a video in the playhouse feature
///
/// Contains all the essential information about a video including
/// its metadata and category information
class Video {
  /// Unique identifier for the video
  final String id;
  
  /// Title of the video
  final String title;
  
  /// URL to the video thumbnail image
  final String thumbnailUrl;
  
  /// YouTube video ID for playback
  final String videoId;
  
  /// Description of the video content
  final String description;
  
  /// Tags associated with the video for categorization and search
  final List<String> tags;
  
  /// Optional category the video belongs to
  final String? category;

  /// Creates a new Video entity
  const Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
    required this.description,
    this.tags = const [],
    this.category,
  });
}