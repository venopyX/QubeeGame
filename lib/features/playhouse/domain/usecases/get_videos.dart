import '../entities/video.dart';
import '../repositories/playhouse_repository.dart';

/// Use case for retrieving available videos
class GetVideos {
  /// The repository that provides access to video data
  final PlayhouseRepository repository;

  /// Creates a GetVideos use case with the specified repository
  const GetVideos(this.repository);

  /// Executes the use case to retrieve all videos
  ///
  /// Returns a list of available videos
  Future<List<Video>> call() async {
    return await repository.getVideos();
  }
}
