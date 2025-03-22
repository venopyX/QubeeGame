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
  int _score = 0;
  String? _error;
  Map<String, dynamic> _stats = {};
  
  // For tracking game play time
  DateTime? _gameStartTime;
  
  // For scrambled word order
  List<String> _scrambledWordIds = [];

  WordMatchingProvider(this.getWordPairs);

  WordMatchingStatus get status => _status;
  List<WordPair> get allWordPairs => _allWordPairs;
  List<WordPair> get gameWordPairs => _gameWordPairs;
  List<String> get scrambledWordIds => _scrambledWordIds;
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
      
      // Load global stats
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
    _gameStartTime = DateTime.now();
    
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
    
    // Create a scrambled order for words
    _scrambledWordIds = _gameWordPairs.map((pair) => pair.id).toList()..shuffle(Random());
    
    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  // Method to replay the current game with the same words but reshuffled
  void replayCurrentGame() {
    // Reset score and matched status
    _score = 0;
    _matched = {};
    
    // Keep the same game word pairs but reset the match status
    for (var pair in _gameWordPairs) {
      _matched[pair.id] = false;
    }
    
    // Reshuffle the word order
    _scrambledWordIds = _gameWordPairs.map((pair) => pair.id).toList()..shuffle(Random());
    
    // Reset the game timer
    _gameStartTime = DateTime.now();
    
    // Set status back to playing
    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  // Method to start a completely new game with new word pairs
  void startNewGame(int numberOfPairs) {
    // Reset game state but keep current category
    _score = 0;
    _matched = {};
    _gameStartTime = DateTime.now();
    
    // Get a fresh set of words for the selected category
    final sourceWordPairs = _selectedCategory == 'all' 
        ? _allWordPairs 
        : _wordPairsByCategory[_selectedCategory] ?? [];
    
    if (sourceWordPairs.isEmpty) {
      _error = 'No word pairs available for this category';
      _status = WordMatchingStatus.error;
      notifyListeners();
      return;
    }
    
    // Completely shuffle and select new pairs
    final shuffledPairs = List<WordPair>.from(sourceWordPairs)..shuffle(Random());
    _gameWordPairs = shuffledPairs.take(numberOfPairs).toList();
    
    // Initialize match status
    for (var pair in _gameWordPairs) {
      _matched[pair.id] = false;
    }
    
    // Create a fresh scrambled order for words
    _scrambledWordIds = _gameWordPairs.map((pair) => pair.id).toList()..shuffle(Random());
    
    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  // NEW METHOD: Direct update of matched status
  void updateMatchedStatus(String wordId, bool isMatched) {
    _matched[wordId] = isMatched;
    print("Updated matched status for $wordId to $isMatched");
    print("Current matched status: $_matched");
    notifyListeners();
  }

  // NEW METHOD: Direct increment of score
  void incrementScore() {
    _score++;
    print("Score incremented to $_score/${_gameWordPairs.length}");
    notifyListeners();
  }

  // NEW METHOD: Direct game completion trigger
  void completeGame() {
    print("completeGame() called with score $_score/${_gameWordPairs.length}");
    _status = WordMatchingStatus.completed;
    notifyListeners();
    
    // Save game results
    try {
      getWordPairs.saveResult(
        _score, 
        _gameWordPairs.length,
        category: _selectedCategory
      ).then((_) {
        // Refresh stats after saving
        getWordPairs.getStats().then((updatedStats) {
          _stats = updatedStats;
          print("Game stats saved and refreshed: $_stats");
          notifyListeners();
        });
      });
    } catch (e) {
      print("Error saving game result: $e");
      _error = 'Failed to save game result: ${e.toString()}';
      notifyListeners();
    }
  }

  void resetGame() {
    // Reset to category selection view
    _status = WordMatchingStatus.loaded;
    notifyListeners();
  }

  bool isAllMatched() {
    final allMatched = _matched.values.every((m) => m);
    print("isAllMatched() = $allMatched");
    return allMatched;
  }
  
  // Get a word pair by ID
  WordPair getWordPairById(String id) {
    try {
      return _gameWordPairs.firstWhere((pair) => pair.id == id);
    } catch (e) {
      print("Error: Word pair with ID $id not found!");
      throw Exception('Word pair not found: $id');
    }
  }
}