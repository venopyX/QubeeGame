import '../entities/video.dart';

abstract class PlayhouseRepository {
  Future<List<Video>> getVideos();
  Future<String?> getLastWatchedVideoId();
  Future<void> saveLastWatchedVideoId(String videoId);
}