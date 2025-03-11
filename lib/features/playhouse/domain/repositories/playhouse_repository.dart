import '../entities/video.dart';
import '../entities/playhouse_progress.dart';

abstract class PlayhouseRepository {
  Future<List<Video>> getVideos();
  Future<void> markVideoCompleted(String videoId);
  Future<void> addStars(int count);
  Future<PlayhouseProgress> getProgress();
  Future<void> saveProgress(PlayhouseProgress progress);
}