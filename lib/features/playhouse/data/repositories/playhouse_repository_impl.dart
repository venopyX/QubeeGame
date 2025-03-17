import '../../domain/entities/video.dart';
import '../../domain/repositories/playhouse_repository.dart';
import '../datasources/playhouse_datasource.dart';

class PlayhouseRepositoryImpl implements PlayhouseRepository {
  final PlayhouseDatasource datasource;

  PlayhouseRepositoryImpl(this.datasource);

  @override
  Future<List<Video>> getVideos() async {
    return await datasource.getVideos();
  }

  @override
  Future<String?> getLastWatchedVideoId() async {
    return await datasource.getLastWatchedVideoId();
  }

  @override
  Future<void> saveLastWatchedVideoId(String videoId) async {
    await datasource.saveLastWatchedVideoId(videoId);
  }
}