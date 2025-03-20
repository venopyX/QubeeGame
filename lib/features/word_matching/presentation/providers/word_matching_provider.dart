import 'package:flutter/material.dart';
import 'dart:math';
import '../../domain/entities/word_pair.dart';
import '../../domain/usecases/get_word_pairs.dart';

enum WordMatchingStatus { initial, loading, loaded, playing, completed, error }

class WordMatchingProvider extends ChangeNotifier {
  final GetWordPairs getWordPairs;
  
  WordMatchingStatus _status = WordMatchingStatus.initial;
  List<WordPair> _allWordPairs = [];
  List<WordPair> _gameWordPairs = [];
  Map<String, List<WordPair>> _wordPairsByCategory = {};
  String _selectedCategory = 'all';
  Map<String, bool> _matched = {};
  String? _draggedWord;
  int _score = 0;
  String? _error;
  Map<String, dynamic> _stats = {};

  WordMatchingProvider(this.getWordPairs);

  WordMatchingStatus get status => _status;
  List<WordPair> get allWordPairs => _allWordPairs;
  List<WordPair> get gameWordPairs => _gameWordPairs;
  List<String> get categories => _wordPairsByCategory.keys.toList();
  String get selectedCategory => _selectedCategory;
  Map<String, bool> get matched => _matched;
  int get score => _score;
  String? get error => _error;
  Map<String, dynamic> get stats => _stats;

  Future<void> loadWordPairs() async {
    _status = WordMatchingStatus.loading;
    notifyListeners();

    try {
      final wordPairs = await getWordPairs();
      _allWordPairs = wordPairs;
      
      // Group word pairs by category
      _wordPairsByCategory = {'all': wordPairs};
      
      for (final pair in wordPairs) {
        if (!_wordPairsByCategory.containsKey(pair.category)) {
          _wordPairsByCategory[pair.category] = [];
        }
        _wordPairsByCategory[pair.category]!.add(pair);
      }
      
      // Load stats
      _stats = await getWordPairs.getStats();
      
      _status = WordMatchingStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = WordMatchingStatus.error;
    }
    
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void startGame([int numberOfPairs = 4]) {
    // Reset game state
    _score = 0;
    _matched = {};
    
    // Get words for selected category
    final sourceWordPairs = _selectedCategory == 'all' 
        ? _allWordPairs 
        : _wordPairsByCategory[_selectedCategory] ?? [];
    
    if (sourceWordPairs.isEmpty) {
      _error = 'No word pairs available for this category';
      _status = WordMatchingStatus.error;
      notifyListeners();
      return;
    }
    
    // Shuffle and select a limited number of pairs
    final shuffledPairs = List<WordPair>.from(sourceWordPairs)..shuffle(Random());
    _gameWordPairs = shuffledPairs.take(numberOfPairs).toList();
    
    // Initialize match status
    for (var pair in _gameWordPairs) {
      _matched[pair.id] = false;
    }
    
    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  void setDraggedWord(String? wordId) {
    _draggedWord = wordId;
    notifyListeners();
  }

  bool attemptMatch(String targetPairId) {
    if (_draggedWord == null) return false;
    
    // Find the dragged pair and target pair
    final draggedPair = _gameWordPairs.firstWhere((pair) => pair.id == _draggedWord);
    final targetPair = _gameWordPairs.firstWhere((pair) => pair.id == targetPairId);
    
    // Check if this is a match
    final isCorrect = draggedPair.id == targetPair.id;
    
    if (isCorrect) {
      _matched[targetPairId] = true;
      _score++;
      
      // Check if game is completed
      if (_matched.values.every((matched) => matched)) {
        _completeGame();
      }
    }
    
    // Clear the dragged word
    _draggedWord = null;
    notifyListeners();
    
    return isCorrect;
  }

  void _completeGame() async {
    _status = WordMatchingStatus.completed;
    
    // Save game results
    try {
      await getWordPairs.saveResult(_score, _gameWordPairs.length);
      _stats = await getWordPairs.getStats();
    } catch (e) {
      _error = 'Failed to save game result: ${e.toString()}';
    }
    
    notifyListeners();
  }

  void resetGame() {
    _status = WordMatchingStatus.loaded;
    notifyListeners();
  }

  bool isAllMatched() {
    return _matched.values.every((m) => m);
  }
}