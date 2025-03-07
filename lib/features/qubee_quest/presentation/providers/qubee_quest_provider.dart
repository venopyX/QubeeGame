import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/qubee.dart';
import '../../domain/entities/land.dart';
import '../../domain/entities/treasure.dart';
import '../../domain/usecases/get_qubee_letters.dart';
import '../../domain/usecases/get_lands.dart';
import '../../data/models/qubee_model.dart';  // Add this import
import '../../data/models/land_model.dart';   // Add this import

class QubeeQuestProvider with ChangeNotifier {
  final GetQubeeLetters _getQubeeLetters;
  final GetLands _getLands;
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<Qubee> _letters = [];
  List<Land> _lands = [];
  List<Treasure> _treasures = [];
  
  Qubee? _currentLetter;
  Land? _currentLand;

  int _points = 0;
  bool _isLoading = false;
  bool _isTracingActive = false;
  bool _hasCompletedTracing = false;

  QubeeQuestProvider(this._getQubeeLetters, this._getLands) {
    _initializeGame();
  }

  List<Qubee> get letters => _letters;
  List<Land> get lands => _lands;
  List<Treasure> get treasures => _treasures;
  List<Treasure> get collectedTreasures => _treasures.where((t) => t.isCollected).toList();

  Qubee? get currentLetter => _currentLetter;
  Land? get currentLand => _currentLand;
  
  int get points => _points;
  bool get isLoading => _isLoading;
  bool get isTracingActive => _isTracingActive;
  bool get hasCompletedTracing => _hasCompletedTracing;

  Future<void> _initializeGame() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load letters and lands
      _letters = await _getQubeeLetters();
      _lands = await _getLands();

      // Update unlocked status based on points
      _updateUnlockStatus();

      // Initialize treasures based on letters
      _initializeTreasures();
      
      // Set initial land and letter
      _setInitialLandAndLetter();
      
    } catch (e) {
      debugPrint('Error initializing game: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateUnlockStatus() {
    // Update lands unlock status
    for (var land in _lands) {
      land.isUnlocked = land.requiredPoints <= _points;
    }

    // Update letters unlock status
    for (var letter in _letters) {
      letter.isUnlocked = letter.requiredPoints <= _points;
    }
  }

  void _initializeTreasures() {
    _treasures = [];
    int id = 1;
    
    for (var letter in _letters) {
      for (var word in letter.unlockedWords) {
        _treasures.add(
          Treasure(
            id: id++,
            word: word,
            meaning: 'Meaning of $word', // In a real app, this would be loaded from data
            imagePath: 'assets/images/treasures/${word.toLowerCase()}.png',
            qubeeLetterId: letter.id,
            isCollected: false,
          ),
        );
      }
    }
  }

  void _setInitialLandAndLetter() {
    // Set first unlocked land as current
    _currentLand = _lands.firstWhere(
      (land) => land.isUnlocked, 
      orElse: () => _lands.isNotEmpty ? _lands.first : LandModel( // Fix: Return LandModel instead of Land
        id: 0,
        name: "Default Land",
        description: "Default land description",
        imagePath: "",
        letterIds: [],
        isUnlocked: true,
        requiredPoints: 0,
      ),
    );
    
    // Set first letter of the current land as current letter
    if (_currentLand != null && _currentLand!.letterIds.isNotEmpty) {
      final firstLetterId = _currentLand!.letterIds.first;
      _currentLetter = _letters.firstWhere(
        (letter) => letter.id == firstLetterId,
        orElse: () => _letters.isNotEmpty ? _letters.first : QubeeModel( // Fix: Return QubeeModel instead of Qubee
          id: 0,
          letter: "A",
          pronunciation: "Ah",
          soundPath: "",
          tracingPoints: [],
          unlockedWords: [],
          requiredPoints: 0,
        ),
      );
    }
  }

  // Select a land and update current letter
  void selectLand(Land land) {
    if (!land.isUnlocked) return;
    
    _currentLand = land;
    
    // Select first letter in the land that is not completed yet
    if (land.letterIds.isNotEmpty) {
      final uncompletedLetterIds = land.letterIds.where((id) {
        final letter = _letters.firstWhere(
          (l) => l.id == id,
          orElse: () => QubeeModel( // Fix: Return QubeeModel instead of Qubee
            id: 0,
            letter: "A",
            pronunciation: "Ah",
            soundPath: "",
            tracingPoints: [],
            unlockedWords: [],
            requiredPoints: 0,
          ),
        );
        return !letter.isCompleted;
      }).toList();
      
      if (uncompletedLetterIds.isNotEmpty) {
        final firstLetterId = uncompletedLetterIds.first;
        _currentLetter = _letters.firstWhere(
          (letter) => letter.id == firstLetterId,
          orElse: () => QubeeModel( // Fix: Return QubeeModel instead of Qubee
            id: 0,
            letter: "A",
            pronunciation: "Ah",
            soundPath: "",
            tracingPoints: [],
            unlockedWords: [],
            requiredPoints: 0,
          ),
        );
      } else {
        // If all completed, just select the first letter
        _currentLetter = _letters.firstWhere(
          (letter) => letter.id == land.letterIds.first,
          orElse: () => QubeeModel( // Fix: Return QubeeModel instead of Qubee
            id: 0,
            letter: "A",
            pronunciation: "Ah",
            soundPath: "",
            tracingPoints: [],
            unlockedWords: [],
            requiredPoints: 0,
          ),
        );
      }
    }
    
    notifyListeners();
  }

  // Select a specific letter
  void selectLetter(Qubee letter) {
    if (!letter.isUnlocked) return;
    _currentLetter = letter;
    notifyListeners();
  }

  // Start letter tracing mode
  void startTracing() {
    _isTracingActive = true;
    _hasCompletedTracing = false;
    notifyListeners();
  }

  // Complete letter tracing
  void completeTracing() {
    if (_currentLetter != null && !_currentLetter!.isCompleted) {
      _currentLetter!.isCompleted = true;
      _hasCompletedTracing = true;
      _addPoints(10); // Add points for completing tracing
      
      // Collect treasures related to this letter
      _collectTreasures(_currentLetter!.id);
    }
    
    _isTracingActive = false;
    notifyListeners();
  }

  // Add points and update unlock status
  void _addPoints(int amount) {
    _points += amount;
    _updateUnlockStatus();
    notifyListeners();
  }

  // Collect treasures related to a letter
  void _collectTreasures(int letterId) {
    for (var treasure in _treasures) {
      if (treasure.qubeeLetterId == letterId && !treasure.isCollected) {
        treasure.isCollected = true;
      }
    }
  }

  // Play letter sound
  Future<void> playLetterSound() async {
    if (_currentLetter == null) return;
    
    try {
      await _audioPlayer.setAsset(_currentLetter!.soundPath);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}