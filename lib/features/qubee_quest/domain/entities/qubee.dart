class Qubee {
  final int id;
  final String letter;
  final String smallLetter;
  final String latinEquivalent;
  final String pronunciation;
  final String soundPath;
  final List<Map<String, double>> tracingPoints;
  final List<String> unlockedWords;
  final String exampleSentence;
  final String meaningOfSentence;
  final int requiredPoints;
  bool isUnlocked;
  bool isCompleted;
  double tracingAccuracy;
  int practiceCount;

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