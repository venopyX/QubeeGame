import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/qubee.dart';
import '../../domain/entities/treasure.dart';
import '../../data/datasources/qubee_letter_generator.dart';

class QubeeQuestProvider extends ChangeNotifier {
  // State variables
  List<Qubee> _letters = [];
  List<Treasure> _treasures = [];
  Qubee? _currentLetter;
  int _points = 0;
  bool _audioEnabled = true;
  bool _showAudioError = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Getters
  List<Qubee> get letters => _letters;
  List<Treasure> get treasures => _treasures;
  Qubee? get currentLetter => _currentLetter;
  int get points => _points;
  bool get audioEnabled => _audioEnabled;
  bool get showAudioError => _showAudioError;

  // Constructor
  QubeeQuestProvider() {
    _initializeData();
  }

  // Load data
  Future<void> _initializeData() async {
    try {
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

      _currentLetter = _letters.firstWhereOrNull((letter) => letter.isUnlocked);

      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing data: $e');
    }
  }

  // Select a letter
  void selectLetter(int letterId) {
    final letter = _letters.firstWhereOrNull((l) => l.id == letterId);
    if (letter != null && letter.isUnlocked) {
      _currentLetter = letter;
      notifyListeners();
    }
  }

  // Mark letter as completed - UPDATED to use both accuracy and pathCoverage
  void completeCurrentLetter(double accuracy, double pathCoverage) {
    if (_currentLetter == null) return;

    final index = _letters.indexWhere((l) => l.id == _currentLetter!.id);
    if (index >= 0) {
      _letters[index].isCompleted = true;
      _letters[index].tracingAccuracy = accuracy;
      _letters[index].practiceCount++;

      // Calculate points based on accuracy and path coverage
      // With a maximum of 10 points (5 points for each metric)
      int earnedPoints = ((accuracy * 5) + (pathCoverage * 5)).round();
      earnedPoints = earnedPoints.clamp(0, 10); // Ensure it never exceeds 10

      _addPoints(earnedPoints);

      _collectTreasures(_currentLetter!.id);

      _unlockNextLetter();

      notifyListeners();
    }
  }

  // Unlock next letter
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

  // Update unlock status based on points
  void _updateUnlockStatus() {
    for (int i = 0; i < _letters.length; i++) {
      if (!_letters[i].isUnlocked && _points >= _letters[i].requiredPoints) {
        _letters[i].isUnlocked = true;
      }
    }
  }

  // Add points and update unlock status
  void _addPoints(int amount) {
    _points += amount;
    _updateUnlockStatus();
    notifyListeners();
  }

  // Collect treasures related to a letter
  void _collectTreasures(int letterId) {
    for (var i = 0; i < _treasures.length; i++) {
      if (_treasures[i].qubeeLetterId == letterId &&
          !_treasures[i].isCollected) {
        _treasures[i].isCollected = true;
      }
    }
  }

  // Toggle audio
  void toggleAudio() {
    _audioEnabled = !_audioEnabled;
    notifyListeners();
  }

  // Play letter sound with improved error handling
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

  // Play sound effect with improved error handling
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

  // Get treasure for a letter
  Treasure? getTreasureForLetter(int letterId) {
    return _treasures.firstWhereOrNull(
      (t) => t.qubeeLetterId == letterId && t.isCollected,
    );
  }

  // Get letter progress percentage across all letters
  double get overallProgress {
    if (_letters.isEmpty) return 0.0;
    return _letters.where((l) => l.isCompleted).length / _letters.length;
  }

  // Get unlocked letter count
  int get unlockedLetterCount => _letters.where((l) => l.isUnlocked).length;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

// Helper extension to get firstWhereOrNull functionality
extension FirstWhereExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
