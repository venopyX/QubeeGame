import '../../domain/entities/word_pair.dart';
import '../../domain/repositories/word_matching_repository.dart';
import '../datasources/word_matching_datasource.dart';

class WordMatchingRepositoryImpl implements WordMatchingRepository {
  final WordMatchingDatasource datasource;

  WordMatchingRepositoryImpl(this.datasource);

  @override
  Future<List<WordPair>> getWordPairs() async {
    return await datasource.getWordPairs();
  }

  @override
  Future<List<WordPair>> getWordPairsByCategory(String category) async {
    return await datasource.getWordPairsByCategory(category);
  }

  @override
  Future<void> saveGameResult(int score, int totalQuestions, {String? category}) async {
    await datasource.saveGameResult(score, totalQuestions, category: category);
  }

  @override
  Future<Map<String, dynamic>> getGameStats() async {
    return await datasource.getGameStats();
  }
  
  @override
  WordMatchingDatasource get getDatasource => datasource;
}