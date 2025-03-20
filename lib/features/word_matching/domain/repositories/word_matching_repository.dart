import '../entities/word_pair.dart';

abstract class WordMatchingRepository {
  Future<List<WordPair>> getWordPairs();
  Future<List<WordPair>> getWordPairsByCategory(String category);
  Future<void> saveGameResult(int score, int totalQuestions);
  Future<Map<String, dynamic>> getGameStats();
}