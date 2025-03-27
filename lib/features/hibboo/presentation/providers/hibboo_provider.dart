import 'package:flutter/material.dart';
import '../../domain/entities/hibboo.dart';
import '../../domain/usecases/get_hibboo_list.dart';

/// Provider class for managing Hibboo state and business logic
class HibbooProvider with ChangeNotifier {
  /// Use case for retrieving Hibboo data
  final GetHibbooList getHibbooList;

  /// List of all available Hibboo riddles
  List<Hibboo> _hibbooList = [];

  /// Index of the current Hibboo riddle
  int _currentIndex = 0;

  /// Growth points earned by the user
  int _growthPoints = 0;

  /// Counter for total correct answers
  int _correctAnswers = 0;

  /// Creates a new HibbooProvider and loads initial data
  HibbooProvider(this.getHibbooList) {
    loadHibbooList();
  }

  /// Gets the full list of Hibboo riddles
  List<Hibboo> get hibbooList => _hibbooList;

  /// Gets the current Hibboo riddle being displayed
  Hibboo get currentHibboo =>
      _hibbooList.isNotEmpty
          ? _hibbooList[_currentIndex]
          : const Hibboo(text: '', answer: '', level: 1);

  /// Gets the difficulty level of the current Hibboo
  int get currentLevel => currentHibboo.level;

  /// Gets the current growth points
  int get growthPoints => _growthPoints;

  /// Gets the total number of correctly answered Hibboos
  int get correctAnswers => _correctAnswers;

  /// Whether data is still loading
  bool get isLoading => _hibbooList.isEmpty;

  /// Whether the user has unlocked the achievement
  bool get hasAchievement => _correctAnswers >= 65;

  /// Maps the current level to a tree growth stage name
  String get currentStage {
    switch (currentLevel) {
      case 1:
        return 'Seedling';
      case 2:
        return 'Sapling';
      case 3:
        return 'Young Tree';
      case 4:
        return 'Mature Tree';
      case 5:
        return 'Grand Tree';
      default:
        return currentLevel > 5 ? 'Grand Tree' : 'Seedling';
    }
  }

  /// Loads the Hibboo list from the repository
  Future<void> loadHibbooList() async {
    _hibbooList = await getHibbooList();
    notifyListeners();
  }

  /// Marks the current Hibboo as solved and advances to the next one
  ///
  /// Returns the solved Hibboo
  Hibboo solveAndAdvance() {
    if (_hibbooList.isEmpty) {
      return const Hibboo(text: '', answer: '', level: 1);
    }

    final currentHibboo = _hibbooList[_currentIndex];

    _growthPoints += 10;
    _correctAnswers += 1;

    _currentIndex = (_currentIndex + 1) % _hibbooList.length;

    if (_growthPoints >= 100) {
      _growthPoints = 0;
    }

    notifyListeners();
    return currentHibboo;
  }

  /// Legacy method for backward compatibility
  void solveHibboo() {
    solveAndAdvance();
  }

  /// Returns Hibboo riddles filtered by difficulty level
  List<Hibboo> getHibboosByLevel(int level) {
    return _hibbooList.where((hibboo) => hibboo.level == level).toList();
  }

  /// Resets achievement progress (for testing)
  void resetAchievement() {
    _correctAnswers = 0;
    notifyListeners();
  }
}
