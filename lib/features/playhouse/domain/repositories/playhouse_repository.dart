import '../entities/video.dart';

/// Repository interface for accessing video data
abstract class PlayhouseRepository {
  /// Retrieves a list of all available videos
  Future<List<Video>> getVideos();
  
  /// Gets the ID of the last watched video
  Future<String?> getLastWatchedVideoId();
  
  /// Saves the ID of the last watched video
  Future<void> saveLastWatchedVideoId(String videoId);
}