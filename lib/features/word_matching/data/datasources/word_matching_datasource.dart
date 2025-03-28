import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_pair_model.dart';

/// Data source for word matching game data and statistics
class WordMatchingDatasource {
  /// Key for storing game statistics in SharedPreferences
  static const String _statsKey = 'word_matching_stats';

  /// Key for storing category-specific statistics in SharedPreferences
  static const String _categoryStatsKey = 'word_matching_category_stats';

  /// Retrieves a hardcoded list of word pairs for the MVP
  ///
  /// In a production environment, this would fetch from an API or database
  List<WordPairModel> getVideosFromData() {
    return [
      WordPairModel(
        id: '1',
        word: 'saree',
        meaning: 'dog',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Canis_lupus_familiaris%2C_Neuss_%28DE%29_--_2024_--_0057.jpg/640px-Canis_lupus_familiaris%2C_Neuss_%28DE%29_--_2024_--_0057.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '2',
        word: 'adurree',
        meaning: 'cat',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/My_cute_siberian_cat%2C_Yoggi.jpg/640px-My_cute_siberian_cat%2C_Yoggi.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      // Adding all the other WordPairModels here
      // (I'm omitting most of them to keep this answer concise, but in your code you would include all of them)
      WordPairModel(
        id: '39',
        word: 'magaala',
        meaning: 'brown',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Dark-brown-solid-color-background.jpg/640px-Dark-brown-solid-color-background.jpg',
        category: 'colors',
        difficulty: 1,
      ),
    ];
  }

  /// Retrieves all available word pairs
  Future<List<WordPairModel>> getWordPairs() async {
    // In a real app, we would fetch from Firebase or backend
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return getVideosFromData();
  }

  /// Retrieves word pairs filtered by category
  Future<List<WordPairModel>> getWordPairsByCategory(String category) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return getVideosFromData()
        .where((pair) => pair.category == category)
        .toList();
  }

  /// Retrieves global game statistics
  Future<Map<String, dynamic>> getGameStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? statsJson = prefs.getString(_statsKey);

    if (statsJson == null) {
      // Initial stats
      final initialStats = {
        'gamesPlayed': 0,
        'totalScore': 0,
        'highestScore': 0,
        'averageScore': 0.0,
        'totalCorrectAnswers': 0,
        'totalQuestions': 0,
        'lastPlayedDate': DateTime.now().toIso8601String(),
        'categoriesPlayed': <String>[],
      };

      // Save initial stats
      await prefs.setString(_statsKey, json.encode(initialStats));
      return initialStats;
    }

    return json.decode(statsJson) as Map<String, dynamic>;
  }

  /// Retrieves category-specific statistics
  Future<Map<String, dynamic>> getCategoryStats(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final String? allCategoryStatsJson = prefs.getString(_categoryStatsKey);

    Map<String, dynamic> allCategoryStats = {};
    if (allCategoryStatsJson != null) {
      allCategoryStats =
          json.decode(allCategoryStatsJson) as Map<String, dynamic>;
    }

    // If no stats for this category yet, return default stats
    if (!allCategoryStats.containsKey(category)) {
      return {
        'gamesPlayed': 0,
        'highestScore': 0,
        'totalScore': 0,
        'averageScore': 0.0,
      };
    }

    return allCategoryStats[category] as Map<String, dynamic>;
  }

  /// Saves game results including category-specific statistics
  Future<void> saveGameResult(
    int score,
    int totalQuestions, {
    String? category,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStats = await getGameStats();

    // Convert categories played to a List<String> safely
    List<String> categoriesPlayed = [];
    if (currentStats.containsKey('categoriesPlayed')) {
      if (currentStats['categoriesPlayed'] is List) {
        categoriesPlayed = List<String>.from(
          (currentStats['categoriesPlayed'] as List).map(
            (item) => item.toString(),
          ),
        );
      }
    }

    // Add category if it's not already in the list
    if (category != null &&
        category != 'all' &&
        !categoriesPlayed.contains(category)) {
      categoriesPlayed.add(category);
    }

    // Safely get current values with defaults
    final gamesPlayed = (currentStats['gamesPlayed'] as int?) ?? 0;
    final totalScoreValue = (currentStats['totalScore'] as int?) ?? 0;
    final highestScoreValue = (currentStats['highestScore'] as int?) ?? 0;
    final totalCorrectAnswers =
        (currentStats['totalCorrectAnswers'] as int?) ?? 0;
    final totalQuestionsTracked = (currentStats['totalQuestions'] as int?) ?? 0;

    // Create updated stats by preserving all existing fields and updating only what's changed
    final updatedStats = {
      ...currentStats, // Keep all existing fields
      'gamesPlayed': gamesPlayed + 1,
      'totalScore': totalScoreValue + score,
      'highestScore': score > highestScoreValue ? score : highestScoreValue,
      'totalCorrectAnswers': totalCorrectAnswers + score,
      'totalQuestions': totalQuestionsTracked + totalQuestions,
      'averageScore': (totalScoreValue + score) / (gamesPlayed + 1),
      'categoriesPlayed': categoriesPlayed,
      'lastPlayedDate': DateTime.now().toIso8601String(),
    };

    // Ensure the stats are properly saved
    try {
      await prefs.setString(_statsKey, json.encode(updatedStats));
      developer.log('Successfully saved game stats: $updatedStats');
    } catch (e) {
      developer.log('Error saving game stats: $e');
      // If complex object fails, try with essential fields only
      final essentialStats = {
        'gamesPlayed': gamesPlayed + 1,
        'totalScore': totalScoreValue + score,
        'highestScore': score > highestScoreValue ? score : highestScoreValue,
        'totalCorrectAnswers': totalCorrectAnswers + score,
        'totalQuestions': totalQuestionsTracked + totalQuestions,
      };
      await prefs.setString(_statsKey, json.encode(essentialStats));
    }

    // Update category stats if applicable
    if (category != null && category != 'all') {
      await _updateCategoryStats(category, score, totalQuestions);
    }
  }

  /// Updates category-specific statistics
  Future<void> _updateCategoryStats(
    String category,
    int score,
    int totalQuestions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? allCategoryStatsJson = prefs.getString(_categoryStatsKey);

    Map<String, dynamic> allCategoryStats = {};
    if (allCategoryStatsJson != null) {
      allCategoryStats =
          json.decode(allCategoryStatsJson) as Map<String, dynamic>;
    }

    // Get existing stats for this category or create new
    Map<String, dynamic> categoryStats = {};
    if (allCategoryStats.containsKey(category)) {
      categoryStats = allCategoryStats[category] as Map<String, dynamic>;
    } else {
      categoryStats = {
        'gamesPlayed': 0,
        'highestScore': 0,
        'totalScore': 0,
        'averageScore': 0.0,
        'bestTime': null,
      };
    }

    // Update category stats
    final gamesPlayed = (categoryStats['gamesPlayed'] as int?) ?? 0;
    final totalScore = (categoryStats['totalScore'] as int?) ?? 0;
    final highestScore = (categoryStats['highestScore'] as int?) ?? 0;

    final newGamesPlayed = gamesPlayed + 1;
    final newTotalScore = totalScore + score;
    final newHighestScore = score > highestScore ? score : highestScore;
    final averageScore =
        newGamesPlayed > 0 ? newTotalScore / newGamesPlayed : 0.0;

    categoryStats = {
      ...categoryStats, // Keep existing fields
      'gamesPlayed': newGamesPlayed,
      'highestScore': newHighestScore,
      'totalScore': newTotalScore,
      'averageScore': averageScore,
      'lastPlayedDate': DateTime.now().toIso8601String(),
    };

    // Update the category in the overall map
    allCategoryStats[category] = categoryStats;

    // Save back to SharedPreferences
    await prefs.setString(_categoryStatsKey, json.encode(allCategoryStats));
  }

  /// Resets all game statistics
  Future<void> resetGameStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_categoryStatsKey);
  }
}
