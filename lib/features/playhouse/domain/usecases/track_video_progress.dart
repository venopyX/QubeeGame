import '../repositories/playhouse_repository.dart';

/// Use case for tracking video watching progress
class TrackVideoProgress {
  /// Repository that provides video tracking capabilities
  final PlayhouseRepository repository;

  /// Creates a TrackVideoProgress use case with the specified repository
  const TrackVideoProgress(this.repository);

  /// Gets the ID of the last video watched by the user
  Future<String?> getLastWatchedVideoId() async {
    return await repository.getLastWatchedVideoId();
  }

  /// Saves the ID of a video that the user has watched
  Future<void> saveLastWatchedVideoId(String videoId) async {
    await repository.saveLastWatchedVideoId(videoId);
  }
}
