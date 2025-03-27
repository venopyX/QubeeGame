import '../../domain/entities/video.dart';
import '../../domain/repositories/playhouse_repository.dart';
import '../datasources/playhouse_datasource.dart';

/// Implementation of the PlayhouseRepository interface
class PlayhouseRepositoryImpl implements PlayhouseRepository {
  /// Data source for retrieving video data
  final PlayhouseDatasource datasource;

  /// Creates a new PlayhouseRepositoryImpl with the specified data source
  const PlayhouseRepositoryImpl(this.datasource);

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
