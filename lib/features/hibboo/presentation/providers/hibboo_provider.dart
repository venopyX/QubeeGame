import 'package:flutter/material.dart';
import '../../domain/entities/hibboo.dart';
import '../../domain/usecases/get_hibboo_list.dart';

class HibbooProvider with ChangeNotifier {
  final GetHibbooList getHibbooList;

  HibbooProvider(this.getHibbooList) {
    loadHibbooList();
  }

  List<Hibboo> _hibbooList = [];
  int _currentIndex = 0;
  int _growthPoints = 0;
  int _correctAnswers = 0; // Track total correct answers

  List<Hibboo> get hibbooList => _hibbooList;
  Hibboo get currentHibboo => _hibbooList.isNotEmpty 
      ? _hibbooList[_currentIndex] 
      : Hibboo(text: '', answer: '', level: 1);
  int get currentLevel => currentHibboo.level;
  int get growthPoints => _growthPoints;
  int get correctAnswers => _correctAnswers; // Getter for correct answers
  bool get isLoading => _hibbooList.isEmpty;
  bool get hasAchievement => _correctAnswers >= 65; // Achievement unlocked at 85+ correct answers

  // Map level to stage name
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
        // Support for future levels - can easily add more stages later
        if (currentLevel > 5) return 'Grand Tree';
        return 'Seedling';
    }
  }

  Future<void> loadHibbooList() async {
    _hibbooList = await getHibbooList();
    notifyListeners();
  }

  // Returns the current hibboo and advances to the next one
  Hibboo solveAndAdvance() {
    if (_hibbooList.isEmpty) return Hibboo(text: '', answer: '', level: 1);
    
    // Store the current hibboo before advancing
    final currentHibboo = _hibbooList[_currentIndex];
    
    // Update counters
    _growthPoints += 10;
    _correctAnswers += 1;
    
    // Move to next hibboo
    _currentIndex = (_currentIndex + 1) % _hibbooList.length;
    
    if (_growthPoints >= 100) {
      _growthPoints = 0;
    }
    
    notifyListeners();
    return currentHibboo; // Return the solved hibboo
  }
  
  // Keeping this for backward compatibility
  void solveHibboo() {
    solveAndAdvance();
  }
  
  // Method to get hibboos filtered by level
  List<Hibboo> getHibboosByLevel(int level) {
    return _hibbooList.where((hibboo) => hibboo.level == level).toList();
  }
  
  // Reset achievement tracking (optional, for testing)
  void resetAchievement() {
    _correctAnswers = 0;
    notifyListeners();
  }
}