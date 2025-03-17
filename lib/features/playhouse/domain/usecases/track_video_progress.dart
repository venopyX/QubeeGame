import '../repositories/playhouse_repository.dart';

class TrackVideoProgress {
  final PlayhouseRepository repository;

  TrackVideoProgress(this.repository);

  Future<String?> getLastWatchedVideoId() async {
    return await repository.getLastWatchedVideoId();
  }

  Future<void> saveLastWatchedVideoId(String videoId) async {
    await repository.saveLastWatchedVideoId(videoId);
  }
}