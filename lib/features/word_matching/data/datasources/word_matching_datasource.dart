import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_pair_model.dart';

class WordMatchingDatasource {
  static const String _statsKey = 'word_matching_stats';
  
  // For the MVP, we'll use hardcoded word pairs data
  // In a real implementation, this would come from Firebase or another backend
  List<WordPairModel> getWordPairsFromData() {
    return [
      // Animals Category
      WordPairModel(
        id: '1',
        word: 'saree',
        meaning: 'dog',
        imageUrl: 'assets/images/animals/dog.png',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '2',
        word: 'adurree',
        meaning: 'cat',
        imageUrl: 'assets/images/animals/cat.png',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '3',
        word: 'loon',
        meaning: 'cow',
        imageUrl: 'assets/images/animals/cow.png',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '4',
        word: 'farda',
        meaning: 'horse',
        imageUrl: 'assets/images/animals/horse.png',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '5',
        word: 'simbiroo',
        meaning: 'bird',
        imageUrl: 'assets/images/animals/bird.png',
        category: 'animals',
        difficulty: 1,
      ),
      
      // Nature Category
      WordPairModel(
        id: '6',
        word: 'bishaan',
        meaning: 'water',
        imageUrl: 'assets/images/nature/water.png',
        category: 'nature',
        difficulty: 1,
      ),
      WordPairModel(
        id: '7',
        word: 'aduu',
        meaning: 'sun',
        imageUrl: 'assets/images/nature/sun.png',
        category: 'nature',
        difficulty: 1,
      ),
      WordPairModel(
        id: '8',
        word: 'gaara',
        meaning: 'mountain',
        imageUrl: 'assets/images/nature/mountain.png',
        category: 'nature',
        difficulty: 2,
      ),
      WordPairModel(
        id: '9',
        word: 'bosonaa',
        meaning: 'forest',
        imageUrl: 'assets/images/nature/forest.png',
        category: 'nature',
        difficulty: 2,
      ),
      
      // Food Category
      WordPairModel(
        id: '10',
        word: 'buddeena',
        meaning: 'bread',
        imageUrl: 'assets/images/food/bread.png',
        category: 'food',
        difficulty: 1,
      ),
      WordPairModel(
        id: '11',
        word: 'anannii',
        meaning: 'milk',
        imageUrl: 'assets/images/food/milk.png',
        category: 'food',
        difficulty: 1,
      ),
      WordPairModel(
        id: '12',
        word: 'mishinga',
        meaning: 'fruit',
        imageUrl: 'assets/images/food/fruit.png',
        category: 'food',
        difficulty: 2,
      ),
      
      // Colors Category
      WordPairModel(
        id: '13',
        word: 'diimaa',
        meaning: 'red',
        imageUrl: 'assets/images/colors/red.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '14',
        word: 'keelloo',
        meaning: 'yellow',
        imageUrl: 'assets/images/colors/yellow.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '15',
        word: 'magariisa',
        meaning: 'green',
        imageUrl: 'assets/images/colors/green.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '16',
        word: 'gurraacha',
        meaning: 'black',
        imageUrl: 'assets/images/colors/black.png',
        category: 'colors',
        difficulty: 1,
      ),
    ];
  }

  Future<List<WordPairModel>> getWordPairs() async {
    // In a real app, we would fetch from Firebase or backend
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return getWordPairsFromData();
  }

  Future<List<WordPairModel>> getWordPairsByCategory(String category) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return getWordPairsFromData()
        .where((pair) => pair.category == category)
        .toList();
  }

  Future<Map<String, dynamic>> getGameStats() async {
    final prefs = await SharedPreferences.getInstance();
    final String? statsJson = prefs.getString(_statsKey);
    
    if (statsJson == null) {
      // Initial stats
      return {
        'gamesPlayed': 0,
        'totalScore': 0,
        'highestScore': 0,
        'categoriesPlayed': <String>[],
      };
    }
    
    return json.decode(statsJson) as Map<String, dynamic>;
  }

  Future<void> saveGameResult(int score, int totalQuestions) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStats = await getGameStats();
    
    final updatedStats = {
      'gamesPlayed': currentStats['gamesPlayed'] + 1,
      'totalScore': currentStats['totalScore'] + score,
      'highestScore': score > (currentStats['highestScore'] ?? 0) ? score : currentStats['highestScore'],
      'categoriesPlayed': currentStats['categoriesPlayed'],
    };
    
    await prefs.setString(_statsKey, json.encode(updatedStats));
  }
}