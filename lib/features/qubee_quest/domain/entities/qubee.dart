/// Entity representing a Qubee letter in the Oromo alphabet
///
/// Contains information about the letter, its pronunciation, tracing points,
/// and associated educational content
class Qubee {
  /// Unique identifier for the letter
  final int id;

  /// The uppercase version of the letter
  final String letter;

  /// The lowercase version of the letter
  final String smallLetter;

  /// The Latin equivalent of the letter
  final String latinEquivalent;

  /// Description of how to pronounce the letter
  final String pronunciation;

  /// Path to the audio file for the letter's pronunciation
  final String soundPath;

  /// Points used to visualize the letter for tracing exercises
  final List<Map<String, double>> tracingPoints;

  /// Words that are unlocked when this letter is learned
  final List<String> unlockedWords;

  /// Example sentence using the letter
  final String exampleSentence;

  /// English translation of the example sentence
  final String meaningOfSentence;

  /// Points required to unlock this letter
  final int requiredPoints;

  /// Whether this letter is unlocked for learning
  bool isUnlocked;

  /// Whether the user has completed learning this letter
  bool isCompleted;

  /// User's accuracy when tracing this letter (0.0 to 1.0)
  double tracingAccuracy;

  /// How many times the user has practiced this letter
  int practiceCount;

  /// Creates a new Qubee letter entity
  Qubee({
    required this.id,
    required this.letter,
    required this.smallLetter,
    required this.latinEquivalent,
    required this.pronunciation,
    required this.soundPath,
    required this.tracingPoints,
    required this.unlockedWords,
    required this.exampleSentence,
    required this.meaningOfSentence,
    required this.requiredPoints,
    this.isUnlocked = false,
    this.isCompleted = false,
    this.tracingAccuracy = 0.0,
    this.practiceCount = 0,
  });
}
