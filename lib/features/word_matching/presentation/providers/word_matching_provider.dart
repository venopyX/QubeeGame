import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'dart:math';
import '../../domain/entities/word_pair.dart';
import '../../domain/usecases/get_word_pairs.dart';

/// Possible states of the word matching game
enum WordMatchingStatus {
  /// Initial state, no data loaded
  initial,

  /// Data is loading
  loading,

  /// Data loaded, waiting for category selection
  loaded,

  /// Game is in progress
  playing,

  /// Game is completed
  completed,

  /// Error state
  error,
}

/// Provider for managing the word matching game state
class WordMatchingProvider extends ChangeNotifier {
  /// Use case for retrieving word pairs
  final GetWordPairs getWordPairs;

  /// Current status of the game
  WordMatchingStatus _status = WordMatchingStatus.initial;

  /// List of all available word pairs
  List<WordPair> _allWordPairs = [];

  /// List of word pairs used in the current game
  List<WordPair> _gameWordPairs = [];

  /// Word pairs organized by category
  Map<String, List<WordPair>> _wordPairsByCategory = {};

  /// Currently selected category
  String _selectedCategory = 'all';

  /// Map tracking which word pairs have been matched
  Map<String, bool> _matched = {};

  /// Current score in the game
  int _score = 0;

  /// Error message if loading failed
  String? _error;

  /// Game statistics
  Map<String, dynamic> _stats = {};

  /// Timestamp when the current game started
  late DateTime? _gameStartTime;

  /// Word IDs in scrambled order for display
  List<String> _scrambledWordIds = [];

  /// Creates a WordMatchingProvider
  WordMatchingProvider(this.getWordPairs);

  /// Current status of the game
  WordMatchingStatus get status => _status;

  /// All available word pairs
  List<WordPair> get allWordPairs => _allWordPairs;

  /// Word pairs used in the current game
  List<WordPair> get gameWordPairs => _gameWordPairs;

  /// Word IDs in scrambled order for display
  List<String> get scrambledWordIds => _scrambledWordIds;

  /// Available categories
  List<String> get categories => _wordPairsByCategory.keys.toList();

  /// Currently selected category
  String get selectedCategory => _selectedCategory;

  /// Map of which word pairs have been matched
  Map<String, bool> get matched => _matched;

  /// Current score in the game
  int get score => _score;

  /// Error message if loading failed
  String? get error => _error;

  /// Game statistics
  Map<String, dynamic> get stats => _stats;

  /// Loads word pairs from the repository
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

  /// Selects a category for gameplay
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Starts a new game with the specified number of pairs
  void startGame([int numberOfPairs = 4]) {
    // Reset game state
    _score = 0;
    _matched = {};
    _gameStartTime = DateTime.now();

    // Get words for selected category
    final sourceWordPairs =
        _selectedCategory == 'all'
            ? _allWordPairs
            : _wordPairsByCategory[_selectedCategory] ?? [];

    if (sourceWordPairs.isEmpty) {
      _error = 'No word pairs available for this category';
      _status = WordMatchingStatus.error;
      notifyListeners();
      return;
    }

    // Shuffle and select a limited number of pairs
    final shuffledPairs = List<WordPair>.from(sourceWordPairs)
      ..shuffle(Random());
    _gameWordPairs = shuffledPairs.take(numberOfPairs).toList();

    // Initialize match status
    for (var pair in _gameWordPairs) {
      _matched[pair.id] = false;
    }

    // Create a scrambled order for words
    _scrambledWordIds =
        _gameWordPairs.map((pair) => pair.id).toList()..shuffle(Random());

    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  /// Replays the current game with the same words
  void replayCurrentGame() {
    // Reset score and matched status
    _score = 0;
    _matched = {};

    // Keep the same game word pairs but reset the match status
    for (var pair in _gameWordPairs) {
      _matched[pair.id] = false;
    }

    // Reshuffle the word order
    _scrambledWordIds =
        _gameWordPairs.map((pair) => pair.id).toList()..shuffle(Random());

    // Reset the game timer
    _gameStartTime = DateTime.now();

    // Set status back to playing
    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  /// Starts a new game with new word pairs
  void startNewGame(int numberOfPairs) {
    // Reset game state but keep current category
    _score = 0;
    _matched = {};
    _gameStartTime = DateTime.now();

    // Get a fresh set of words for the selected category
    final sourceWordPairs =
        _selectedCategory == 'all'
            ? _allWordPairs
            : _wordPairsByCategory[_selectedCategory] ?? [];

    if (sourceWordPairs.isEmpty) {
      _error = 'No word pairs available for this category';
      _status = WordMatchingStatus.error;
      notifyListeners();
      return;
    }

    // Completely shuffle and select new pairs
    final shuffledPairs = List<WordPair>.from(sourceWordPairs)
      ..shuffle(Random());
    _gameWordPairs = shuffledPairs.take(numberOfPairs).toList();

    // Initialize match status
    for (var pair in _gameWordPairs) {
      _matched[pair.id] = false;
    }

    // Create a fresh scrambled order for words
    _scrambledWordIds =
        _gameWordPairs.map((pair) => pair.id).toList()..shuffle(Random());

    _status = WordMatchingStatus.playing;
    notifyListeners();
  }

  /// Updates the matched status for a word pair
  void updateMatchedStatus(String wordId, bool isMatched) {
    _matched[wordId] = isMatched;
    developer.log("Updated matched status for $wordId to $isMatched");
    developer.log("Current matched status: $_matched");
    notifyListeners();
  }

  /// Increments the score
  void incrementScore() {
    _score++;
    developer.log("Score incremented to $_score/${_gameWordPairs.length}");
    notifyListeners();
  }

  /// Completes the current game and saves results
  void completeGame() {
    developer.log("completeGame() called with score $_score/${_gameWordPairs.length}");
    _status = WordMatchingStatus.completed;
    notifyListeners();

    // Save game results
    try {
      getWordPairs
          .saveResult(
            _score,
            _gameWordPairs.length,
            category: _selectedCategory,
          )
          .then((_) {
            // Refresh stats after saving
            getWordPairs.getStats().then((updatedStats) {
              _stats = updatedStats;
              developer.log("Game stats saved and refreshed: $_stats");
              notifyListeners();
            });
          });
    } catch (e) {
      developer.log("Error saving game result: $e");
      _error = 'Failed to save game result: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Resets the game back to category selection
  void resetGame() {
    // Reset to category selection view
    _status = WordMatchingStatus.loaded;
    notifyListeners();
  }

  /// Checks if all word pairs have been matched
  bool isAllMatched() {
    final allMatched = _matched.values.every((m) => m);
    developer.log("isAllMatched() = $allMatched");
    return allMatched;
  }

  /// Gets a word pair by its ID
  WordPair getWordPairById(String id) {
    try {
      return _gameWordPairs.firstWhere((pair) => pair.id == id);
    } catch (e) {
      developer.log("Error: Word pair with ID $id not found!");
      throw Exception('Word pair not found: $id');
    }
  }
}
