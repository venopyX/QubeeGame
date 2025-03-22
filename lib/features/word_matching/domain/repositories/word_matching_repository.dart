import '../entities/word_pair.dart';
import '../../data/datasources/word_matching_datasource.dart';

abstract class WordMatchingRepository {
  Future<List<WordPair>> getWordPairs();
  Future<List<WordPair>> getWordPairsByCategory(String category);
  Future<void> saveGameResult(int score, int totalQuestions);
  Future<Map<String, dynamic>> getGameStats();

  // Expose datasource for direct category stats access
  WordMatchingDatasource get datasource;
}
