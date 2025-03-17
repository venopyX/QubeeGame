import '../entities/video.dart';
import '../repositories/playhouse_repository.dart';

class GetVideos {
  final PlayhouseRepository repository;

  GetVideos(this.repository);

  Future<List<Video>> call() async {
    return await repository.getVideos();
  }
}