import '../entities/word_pair.dart';
import '../../data/datasources/word_matching_datasource.dart';

/// Repository interface for word matching game data
abstract class WordMatchingRepository {
  /// Retrieves all available word pairs
  Future<List<WordPair>> getWordPairs();

  /// Retrieves word pairs filtered by category
  Future<List<WordPair>> getWordPairsByCategory(String category);

  /// Saves the result of a completed game
  Future<void> saveGameResult(
    int score,
    int totalQuestions, {
    String? category,
  });

  /// Retrieves game statistics
  Future<Map<String, dynamic>> getGameStats();

  /// Provides direct access to the datasource for category stats access
  WordMatchingDatasource get getDatasource;
}
