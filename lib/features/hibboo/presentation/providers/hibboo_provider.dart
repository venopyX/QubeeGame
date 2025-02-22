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
  String _currentStage = 'Seedling';
  int _growthPoints = 0;

  List<Hibboo> get hibbooList => _hibbooList;
  Hibboo get currentHibboo => _hibbooList[_currentIndex];
  String get currentStage => _currentStage;
  int get growthPoints => _growthPoints;
  bool get isLoading => _hibbooList.isEmpty;

  Future<void> loadHibbooList() async {
    _hibbooList = await getHibbooList();
    notifyListeners();
  }

  void solveHibboo() {
    _growthPoints += 10;
    _currentIndex++; // Move to next Hibboo
    if (_currentIndex >= _hibbooList.length) {
      _currentIndex = 0; // Reset to start if all solved
    }
    if (_growthPoints >= 100) {
      _growthPoints = 0;
      switch (_currentStage) {
        case 'Seedling':
          _currentStage = 'Sapling';
          break;
        case 'Sapling':
          _currentStage = 'Young Tree';
          break;
        case 'Young Tree':
          _currentStage = 'Mature Tree';
          break;
        case 'Mature Tree':
          _currentStage = 'Grand Tree';
          break;
      }
    }
    notifyListeners();
  }
}