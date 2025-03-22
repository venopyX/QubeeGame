import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word_pair_model.dart';

class WordMatchingDatasource {
  static const String _statsKey = 'word_matching_stats';
  static const String _categoryStatsKey = 'word_matching_category_stats';

  // For the MVP, we'll use hardcoded word pairs data
  // In a real implementation, this would come from Firebase or another backend
  List<WordPairModel> getWordPairsFromData() {
    return [
      // Animals Category
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
      WordPairModel(
        id: '3',
        word: 'loon',
        meaning: 'cow',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Cow_2024.jpg/640px-Cow_2024.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '4',
        word: 'farda',
        meaning: 'horse',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Horse_at_KVASU_Wayanad_upload_by_Vijayanrajapuram_07.jpg/640px-Horse_at_KVASU_Wayanad_upload_by_Vijayanrajapuram_07.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '5',
        word: 'simbiroo',
        meaning: 'bird',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Female_house_sparrow_at_Kodai.jpg/640px-Female_house_sparrow_at_Kodai.jpg',
        category: 'animals',
        difficulty: 1,
      ),

      // Nature Category
      WordPairModel(G
        id: '6',
        word: 'bishaan',
        meaning: 'water',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/Sarca_di_Nambrone%2C_flowing_water_01.jpg/640px-Sarca_di_Nambrone%2C_flowing_water_01.jpg',
        category: 'nature',
        difficulty: 1,
      ),
      WordPairModel(
        id: '7',
        word: 'aduu',
        meaning: 'sun',
        imageUrl:
            'https://universemagazine.com/wp-content/uploads/2022/06/0-1-1024x683.jpg',
        category: 'nature',
        difficulty: 1,
      ),
      WordPairModel(
        id: '8',
        word: 'gaara',
        meaning: 'mountain',
        imageUrl:
            'https://ak-d.tripcdn.com/images/100ehk1439qgs8jc13A81_C_880_350_R5.jpg',
        category: 'nature',
        difficulty: 2,
      ),
      WordPairModel(
        id: '9',
        word: 'bosona',
        meaning: 'forest',
        imageUrl:
            'https://oromianeconomist.com/wp-content/uploads/2013/07/yayo-oromia-forest.jpg',
        category: 'nature',
        difficulty: 2,
      ),

      // Food Category
      WordPairModel(
        id: '10',
        word: 'buddeena',
        meaning: 'bread',
        imageUrl: 'https://i.ytimg.com/vi/vT24Ipw6BTM/hq720.jpg',
        category: 'food',
        difficulty: 1,
      ),
      WordPairModel(
        id: '11',
        word: 'aannan',
        meaning: 'milk',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Milk_001.JPG/640px-Milk_001.JPG',
        category: 'food',
        difficulty: 1,
      ),
      WordPairModel(
        id: '12',
        word: 'Firaafiree',
        meaning: 'fruit',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Fruit_Stall_in_Barcelona_Market.jpg/640px-Fruit_Stall_in_Barcelona_Market.jpg',
        category: 'food',
        difficulty: 2,
      ),

      // Colors Category
      WordPairModel(
        id: '13',
        word: 'diimaa',
        meaning: 'red',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Solid_red.svg/640px-Solid_red.svg.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '14',
        word: 'keelloo',
        meaning: 'yellow',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Solid_yellow.svg/640px-Solid_yellow.svg.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '15',
        word: 'magariisa',
        meaning: 'green',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Solid_green.svg/640px-Solid_green.svg.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '16',
        word: 'gurraacha',
        meaning: 'black',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Solid_black.svg/640px-Solid_black.svg.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '17',
        word: 'cuquliisa',
        meaning: 'blue',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Solid_blue.svg/640px-Solid_blue.svg.png',
        category: 'colors',
        difficulty: 2,
      ),
      WordPairModel(
        id: '18',
        word: 'burtukaana',
        meaning: 'orange',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Solid_orange.svg/640px-Solid_orange.svg.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '19',
        word: 'adii',
        meaning: 'white',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/640px-Solid_white.svg.png',
        category: 'colors',
        difficulty: 1,
      ),
      WordPairModel(
        id: '20',
        word: 'daalacha',
        meaning: 'grey',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Solid_grey.svg/640px-Solid_grey.svg.png',
        category: 'colors',
        difficulty: 2,
      ),
      WordPairModel(
        id: '21',
        word: 'gafarsa',
        meaning: 'buffalo',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Buffalo_in_dirt_in_Yala_National_Park.jpg/640px-Buffalo_in_dirt_in_Yala_National_Park.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '22',
        word: 'gaala',
        meaning: 'camel',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/07._Camel_Profile%2C_near_Silverton%2C_NSW%2C_07.07.2007.jpg/640px-07._Camel_Profile%2C_near_Silverton%2C_NSW%2C_07.07.2007.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '23',
        word: 'hamaaketa',
        meaning: 'cheetah',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Cheetah2.JPG/640px-Cheetah2.JPG',
        category: 'animals',
        difficulty: 2,
      ),
      WordPairModel(
        id: '24',
        word: 'jaldeessa',
        meaning: 'chimpanzee',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Pan_troglodytes_-_Loro_Parque_01.jpg/640px-Pan_troglodytes_-_Loro_Parque_01.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '25',
        word: 'arba',
        meaning: 'elephant',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/African_elephant_%28Loxodonta_africana%29_3.jpg/640px-African_elephant_%28Loxodonta_africana%29_3.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '26',
        word: 'sattawwaa',
        meaning: 'giraffe',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/042_Masai_giraffe_in_the_Serengeti_National_Park_Photo_by_Giles_Laurent.jpg/640px-042_Masai_giraffe_in_the_Serengeti_National_Park_Photo_by_Giles_Laurent.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '27',
        word: 'leenca',
        meaning: 'lion',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Family_of_lions_during_the_mating_season.jpg/640px-Family_of_lions_during_the_mating_season.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '28',
        word: 'naacha',
        meaning: 'crocodile',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Largest_and_longest_Crocodile_in_Entebbe.jpg/640px-Largest_and_longest_Crocodile_in_Entebbe.jpg',
        category: 'animals',
        difficulty: 2,
      ),
      WordPairModel(
        id: '29',
        word: 'qeerransa',
        meaning: 'tiger',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/62/Panthera_tigris_sumatran_subspecies.jpg/640px-Panthera_tigris_sumatran_subspecies.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '30',
        word: 'qocaa',
        meaning: 'turtle/tortoise',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Jonathan_the_tortoise_at_Plantation_House.jpg/640px-Jonathan_the_tortoise_at_Plantation_House.jpg',
        category: 'animals',
        difficulty: 2,
      ),
      WordPairModel(
        id: '31',
        word: 'harreddiidoo',
        meaning: 'zebra',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Zebra_with_Calf_Etosha.jpg/640px-Zebra_with_Calf_Etosha.jpg',
        category: 'animals',
        difficulty: 1,
      ),
      WordPairModel(
        id: '32',
        word: 'laga',
        meaning: 'river',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Mosquito_River_Michigan.jpg/640px-Mosquito_River_Michigan.jpg',
        category: 'nature',
        difficulty: 1,
      ),
      WordPairModel(
        id: '33',
        word: 'rooba/bokkaa',
        meaning: 'rain',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Monsoon_rain_in_Yangon%2C_Myanmar%2C_20160812_082637.jpg/640px-Monsoon_rain_in_Yangon%2C_Myanmar%2C_20160812_082637.jpg',
        category: 'nature',
        difficulty: 2,
      ),
      WordPairModel(
        id: '34',
        word: 'hara/haroo',
        meaning: 'lake',
        imageUrl:
            'https://static.wixstatic.com/media/77f548_04d49cd53dd842cba0691035cfd102cb~mv2.jpg',
        category: 'nature',
        difficulty: 1,
      ),
      WordPairModel(
        id: '35',
        word: 'baaduu',
        meaning: 'cheese',
        imageUrl:
            'https://godairyfree.org/wp-content/uploads/2021/09/Cottage-Cheese-online-vert10.jpg',
        category: 'food',
        difficulty: 1,
      ),
      WordPairModel(
        id: '36',
        word: 'dhadhaa',
        meaning: 'butter',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Aufgelassene_Butter_auf_Einzelbeistellkochplatte_in_Backstube_DSCF3217.JPG/640px-Aufgelassene_Butter_auf_Einzelbeistellkochplatte_in_Backstube_DSCF3217.JPG',
        category: 'food',
        difficulty: 2,
      ),
      WordPairModel(
        id: '37',
        word: 'marqaa',
        meaning: 'porridge',
        imageUrl:
            'https://scontent-lga3-1.xx.fbcdn.net/v/t39.30808-6/463423207_8939251406156644_6347321899840141155_n.jpg?stp=dst-jpg_s600x600_tt6&_nc_cat=103&ccb=1-7&_nc_sid=127cfc&_nc_ohc=Xk_AIVElTxgQ7kNvgGMjzWF&_nc_oc=AdlUKZ1PVsL8DeKK-V6IigIa5U0esf2cQcmioVXE-q9C5Tw2yl-ah-RVX3ijCwOJnZXHHR5V8DoAu3Z2SEql5OZd&_nc_zt=23&_nc_ht=scontent-lga3-1.xx&_nc_gid=4T-E1qymCecTIE91hyEVZw&oh=00_AYHfh_9LXCHr9IINQVHRQgABmJIxr7I9_hrZJJr5BfnavA&oe=67E4013A',
        category: 'food',
        difficulty: 2,
      ),
      WordPairModel(
        id: '38',
        word: 'bildiimaa',
        meaning: 'purple',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Solid_purple.svg/640px-Solid_purple.svg.png',
        category: 'colors',
        difficulty: 2,
      ),
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

  // Get global game statistics
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

  // Get category-specific statistics
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

  // Save game results including category stats
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
      print('Successfully saved game stats: $updatedStats');
    } catch (e) {
      print('Error saving game stats: $e');
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

  // Helper method to update category-specific stats
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

  // Reset all game statistics
  Future<void> resetGameStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_categoryStatsKey);
  }
}
