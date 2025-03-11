import '../entities/playhouse_progress.dart';
import '../repositories/playhouse_repository.dart';

class UpdateProgress {
  final PlayhouseRepository repository;

  UpdateProgress(this.repository);

  Future<void> markVideoCompleted(String videoId) async {
    await repository.markVideoCompleted(videoId);
  }

  Future<void> addStars(int count) async {
    await repository.addStars(count);
  }

  Future<PlayhouseProgress> getProgress() async {
    return await repository.getProgress();
  }

  Future<void> saveProgress(PlayhouseProgress progress) async {
    await repository.saveProgress(progress);
  }
}