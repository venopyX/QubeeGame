class Qubee {
  final int id;
  final String letter;
  final String pronunciation;
  final String soundPath;
  final List<Map<String, double>> tracingPoints;
  final List<String> unlockedWords;
  final int requiredPoints;
  bool isUnlocked;
  bool isCompleted;

  Qubee({
    required this.id,
    required this.letter,
    required this.pronunciation,
    required this.soundPath,
    required this.tracingPoints,
    required this.unlockedWords,
    required this.requiredPoints,
    this.isUnlocked = false,
    this.isCompleted = false,
  });
}