import '../entities/word_pair.dart';
import '../repositories/word_matching_repository.dart';

/// Use case for retrieving and managing word pairs
class GetWordPairs {
  /// The repository providing access to word pairs data
  final WordMatchingRepository repository;

  /// Creates a new GetWordPairs use case
  const GetWordPairs(this.repository);

  /// Retrieves all word pairs
  Future<List<WordPair>> call() async {
    return await repository.getWordPairs();
  }

  /// Retrieves word pairs filtered by category
  Future<List<WordPair>> byCategory(String category) async {
    return await repository.getWordPairsByCategory(category);
  }

  /// Retrieves game statistics
  Future<Map<String, dynamic>> getStats() async {
    return await repository.getGameStats();
  }

  /// Saves the result of a completed game
  Future<void> saveResult(
    int score,
    int totalQuestions, {
    String? category,
  }) async {
    await repository.saveGameResult(score, totalQuestions, category: category);
  }
}
