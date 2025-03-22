import '../entities/word_pair.dart';
import '../repositories/word_matching_repository.dart';

class GetWordPairs {
  final WordMatchingRepository repository;

  GetWordPairs(this.repository);

  Future<List<WordPair>> call() async {
    return await repository.getWordPairs();
  }

  Future<List<WordPair>> byCategory(String category) async {
    return await repository.getWordPairsByCategory(category);
  }

  Future<Map<String, dynamic>> getStats() async {
    return await repository.getGameStats();
  }

  Future<void> saveResult(int score, int totalQuestions, {String? category}) async {
    await repository.saveGameResult(score, totalQuestions, category: category);
  }
}