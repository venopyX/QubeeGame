import '../../domain/entities/video.dart';
import '../../domain/entities/playhouse_progress.dart';
import '../../domain/repositories/playhouse_repository.dart';
import '../datasources/playhouse_datasource.dart';
import '../models/playhouse_progress_model.dart';

class PlayhouseRepositoryImpl implements PlayhouseRepository {
  final PlayhouseDatasource datasource;

  PlayhouseRepositoryImpl(this.datasource);

  @override
  Future<List<Video>> getVideos() async {
    return await datasource.getVideos();
  }

  @override
  Future<void> markVideoCompleted(String videoId) async {
    await datasource.markVideoCompleted(videoId);
  }

  @override
  Future<void> addStars(int count) async {
    await datasource.addStars(count);
  }

  @override
  Future<PlayhouseProgress> getProgress() async {
    return await datasource.getProgress();
  }

  @override
  Future<void> saveProgress(PlayhouseProgress progress) async {
    await datasource.saveProgress(progress as PlayhouseProgressModel);
  }
}