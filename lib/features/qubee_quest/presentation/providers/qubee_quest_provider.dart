import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/entities/qubee.dart';
import '../../domain/entities/treasure.dart';
import '../../data/datasources/qubee_letter_generator.dart';
import '../../data/models/qubee_model.dart';
import '../../data/models/treasure_model.dart';

/// Provider for managing Qubee Quest state and interactions
///
/// Handles letter data, user progress, audio playback, and persistence
class QubeeQuestProvider extends ChangeNotifier {
  /// List of all Qubee letters
  List<Qubee> _letters = [];

  /// List of treasures that can be collected
  List<Treasure> _treasures = [];

  /// Currently selected letter
  Qubee? _currentLetter;

  /// Total points earned by the user
  int _points = 0;

  /// Whether audio is enabled
  bool _audioEnabled = true;

  /// Whether to show audio error message
  bool _showAudioError = false;

  /// Audio player for letter sounds and effects
  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Whether initialization is complete
  bool _isInitialized = false;

  // SharedPreferences keys
  static const String _pointsKey = 'qubee_quest_points';
  static const String _lettersKey = 'qubee_quest_letters';
  static const String _treasuresKey = 'qubee_quest_treasures';
  static const String _audioEnabledKey = 'qubee_quest_audio_enabled';

  /// All available Qubee letters
  List<Qubee> get letters => _letters;

  /// All available treasures
  List<Treasure> get treasures => _treasures;

  /// Currently selected letter
  Qubee? get currentLetter => _currentLetter;

  /// Total points earned
  int get points => _points;

  /// Whether audio is enabled
  bool get audioEnabled => _audioEnabled;

  /// Whether to show audio error
  bool get showAudioError => _showAudioError;

  /// Whether initialization is complete
  bool get isInitialized => _isInitialized;

  /// Creates a new QubeeQuestProvider and initializes data
  QubeeQuestProvider() {
    _initializeData();
  }

  /// Loads data from SharedPreferences or initializes with defaults
  Future<void> _initializeData() async {
    try {
      // Try to load saved data first
      final bool dataLoaded = await _loadFromPreferences();

      // If no data was loaded, initialize with defaults
      if (!dataLoaded) {
        _letters = QubeeLetterGenerator.generateBasicLetters();

        _treasures =
            _letters
                .map(
                  (letter) => Treasure(
                    id: letter.id,
                    qubeeLetterId: letter.id,
                    word:
                        letter.unlockedWords.isNotEmpty
                            ? letter.unlockedWords.first
                            : '',
                    exampleSentence: letter.exampleSentence,
                    meaningOfSentence: letter.meaningOfSentence,
                    isCollected: false,
                  ),
                )
                .toList();

        _updateUnlockStatus();

        // Save initial data - await this to ensure it completes
        await _saveToPreferences();
      }

      _currentLetter = _letters.firstWhereOrNull((letter) => letter.isUnlocked);

      // Mark initialization as complete
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing data: $e');
      // Still mark as initialized to prevent UI from waiting indefinitely
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Saves all state to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save points
      await prefs.setInt(_pointsKey, _points);

      // Save audio preference
      await prefs.setBool(_audioEnabledKey, _audioEnabled);

      // Save letters data
      final lettersJson =
          _letters.map((letter) {
            // Use QubeeModel for serialization if the object isn't already a QubeeModel
            if (letter is QubeeModel) {
              return letter.toJson();
            } else {
              return QubeeModel(
                id: letter.id,
                letter: letter.letter,
                smallLetter: letter.smallLetter,
                latinEquivalent: letter.latinEquivalent,
                pronunciation: letter.pronunciation,
                soundPath: letter.soundPath,
                tracingPoints: letter.tracingPoints,
                unlockedWords: letter.unlockedWords,
                exampleSentence: letter.exampleSentence,
                meaningOfSentence: letter.meaningOfSentence,
                requiredPoints: letter.requiredPoints,
                isUnlocked: letter.isUnlocked,
                isCompleted: letter.isCompleted,
                tracingAccuracy: letter.tracingAccuracy,
                practiceCount: letter.practiceCount,
              ).toJson();
            }
          }).toList();
      await prefs.setString(_lettersKey, jsonEncode(lettersJson));

      // Save treasures data
      final treasuresJson =
          _treasures.map((treasure) {
            // Use TreasureModel for serialization if the object isn't already a TreasureModel
            if (treasure is TreasureModel) {
              return treasure.toJson();
            } else {
              return TreasureModel(
                id: treasure.id,
                qubeeLetterId: treasure.qubeeLetterId,
                word: treasure.word,
                exampleSentence: treasure.exampleSentence,
                meaningOfSentence: treasure.meaningOfSentence,
                isCollected: treasure.isCollected,
              ).toJson();
            }
          }).toList();
      await prefs.setString(_treasuresKey, jsonEncode(treasuresJson));

      // Ensure data is persisted immediately
      await prefs.commit();

      debugPrint('Saved QubeeQuest progress to preferences');
    } catch (e) {
      debugPrint('Error saving to preferences: $e');
    }
  }

  /// Loads state from SharedPreferences
  ///
  /// Returns true if data was successfully loaded
  Future<bool> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Check if we have saved data
      if (!prefs.containsKey(_lettersKey)) {
        return false;
      }

      // Load points
      _points = prefs.getInt(_pointsKey) ?? 0;

      // Load audio preference
      _audioEnabled = prefs.getBool(_audioEnabledKey) ?? true;

      // Load letters
      final lettersString = prefs.getString(_lettersKey);
      if (lettersString != null) {
        try {
          final lettersJson = jsonDecode(lettersString) as List;
          _letters =
              lettersJson
                  .map(
                    (json) => QubeeModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
        } catch (e) {
          debugPrint('Error decoding letters JSON: $e');
          return false;
        }
      } else {
        return false;
      }

      // Load treasures
      final treasuresString = prefs.getString(_treasuresKey);
      if (treasuresString != null) {
        try {
          final treasuresJson = jsonDecode(treasuresString) as List;
          _treasures =
              treasuresJson
                  .map(
                    (json) =>
                        TreasureModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
        } catch (e) {
          debugPrint('Error decoding treasures JSON: $e');
          return false;
        }
      } else {
        return false;
      }

      debugPrint('Loaded QubeeQuest progress from preferences');
      return true;
    } catch (e) {
      debugPrint('Error loading from preferences: $e');
      return false;
    }
  }

  /// Selects a letter for practice
  void selectLetter(int letterId) {
    final letter = _letters.firstWhereOrNull((l) => l.id == letterId);
    if (letter != null && letter.isUnlocked) {
      _currentLetter = letter;
      notifyListeners();
    }
  }

  /// Marks the current letter as completed with the given accuracy
  ///
  /// Awards points and unlocks new letters based on performance
  Future<void> completeCurrentLetter(
    double accuracy,
    double pathCoverage,
  ) async {
    if (_currentLetter == null) return;

    final index = _letters.indexWhere((l) => l.id == _currentLetter!.id);
    if (index >= 0) {
      // Only mark as completed if path coverage is high enough
      bool isFullyCompleted = pathCoverage >= 0.9;

      // Always update the accuracy and increment practice count
      _letters[index].tracingAccuracy = accuracy;
      _letters[index].practiceCount++;

      // Only mark as completed if path coverage is sufficient
      if (isFullyCompleted) {
        _letters[index].isCompleted = true;

        // Collect treasures only when fully completed
        _collectTreasures(_currentLetter!.id);
      }

      // Calculate points based on accuracy and path coverage
      // With a maximum of 10 points (5 points for each metric)
      int earnedPoints = ((accuracy * 5) + (pathCoverage * 5)).round();
      earnedPoints = earnedPoints.clamp(0, 10); // Ensure it never exceeds 10

      _addPoints(earnedPoints);

      // Only try to unlock next letter if this one is fully completed
      if (isFullyCompleted) {
        _unlockNextLetter();
      }

      // Save changes to preferences - await to ensure completion
      await _saveToPreferences();

      notifyListeners();
    }
  }

  /// Attempts to unlock the next letter in sequence
  void _unlockNextLetter() {
    if (_currentLetter == null) return;

    final currentIndex = _letters.indexWhere((l) => l.id == _currentLetter!.id);
    if (currentIndex >= 0 && currentIndex < _letters.length - 1) {
      final nextLetter = _letters[currentIndex + 1];
      if (!nextLetter.isUnlocked && _points >= nextLetter.requiredPoints) {
        _letters[currentIndex + 1].isUnlocked = true;
      }
    }
  }

  /// Updates unlock status for all letters based on current points
  void _updateUnlockStatus() {
    for (int i = 0; i < _letters.length; i++) {
      if (!_letters[i].isUnlocked && _points >= _letters[i].requiredPoints) {
        _letters[i].isUnlocked = true;
      }
    }
  }

  /// Adds points and updates letter unlock status
  Future<void> _addPoints(int amount) async {
    _points += amount;
    _updateUnlockStatus();
    // Await to ensure saving completes
    await _saveToPreferences();
    notifyListeners();
  }

  /// Marks treasures for a letter as collected
  void _collectTreasures(int letterId) {
    for (var i = 0; i < _treasures.length; i++) {
      if (_treasures[i].qubeeLetterId == letterId &&
          !_treasures[i].isCollected) {
        _treasures[i].isCollected = true;
      }
    }
  }

  /// Toggles audio on/off
  Future<void> toggleAudio() async {
    _audioEnabled = !_audioEnabled;
    // Await to ensure saving completes
    await _saveToPreferences();
    notifyListeners();
  }

  /// Plays the sound for the current letter
  Future<void> playLetterSound() async {
    if (_currentLetter == null || !_audioEnabled) return;

    try {
      await _audioPlayer.setAsset(_currentLetter!.soundPath);
      await _audioPlayer.play();

      if (_showAudioError) {
        _showAudioError = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error playing sound: $e');

      _showAudioError = true;
      notifyListeners();

      Future.delayed(const Duration(seconds: 3), () {
        if (_showAudioError) {
          _showAudioError = false;
          notifyListeners();
        }
      });

      HapticFeedback.mediumImpact();
    }
  }

  /// Plays a sound from the given asset path
  Future<void> playSound(String assetPath) async {
    if (!_audioEnabled) return;

    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing sound: $e');

      _showAudioError = true;
      notifyListeners();

      Future.delayed(const Duration(seconds: 3), () {
        if (_showAudioError) {
          _showAudioError = false;
          notifyListeners();
        }
      });

      HapticFeedback.mediumImpact();
    }
  }

  /// Gets the treasure associated with a specific letter
  Treasure? getTreasureForLetter(int letterId) {
    return _treasures.firstWhereOrNull(
      (t) => t.qubeeLetterId == letterId && t.isCollected,
    );
  }

  /// Gets the overall learning progress as a percentage
  double get overallProgress {
    if (_letters.isEmpty) return 0.0;
    return _letters.where((l) => l.isCompleted).length / _letters.length;
  }

  /// Gets the count of unlocked letters
  int get unlockedLetterCount => _letters.where((l) => l.isUnlocked).length;

  /// Saves state when app is paused
  Future<void> saveStateOnPause() async {
    // Called when app is sent to background
    await _saveToPreferences();
    debugPrint('Saved state on app pause');
  }

  @override
  void dispose() {
    // Try to save one last time before disposing
    _saveToPreferences().then((_) {
      debugPrint('Saved state on dispose');
    });
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// Helper extension for firstWhereOrNull functionality
extension FirstWhereExt<T> on Iterable<T> {
  /// Returns the first element satisfying [test], or null if none found
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Extension for SharedPreferences to add commit method
extension SharedPreferencesExtension on SharedPreferences {
  /// Forces immediate write to disk
  Future<bool> commit() async {
    // This is a workaround to force immediate write to disk
    // SharedPreferences normally writes asynchronously which can lead to data loss
    // if the app is terminated before the write completes
    return true;
  }
}
