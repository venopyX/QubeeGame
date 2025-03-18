import '../../domain/entities/qubee.dart';

class QubeeModel extends Qubee {
  QubeeModel({
    required int id,
    required String letter,
    required String smallLetter,
    required String latinEquivalent,
    required String pronunciation,
    required String soundPath,
    required List<Map<String, double>> tracingPoints,
    required List<String> unlockedWords,
    required String exampleSentence,
    required String meaningOfSentence,
    required int requiredPoints,
    bool isUnlocked = false,
    bool isCompleted = false,
  }) : super(
          id: id,
          letter: letter,
          smallLetter: smallLetter,
          latinEquivalent: latinEquivalent,
          pronunciation: pronunciation,
          soundPath: soundPath,
          tracingPoints: tracingPoints,
          unlockedWords: unlockedWords,
          exampleSentence: exampleSentence,
          meaningOfSentence: meaningOfSentence,
          requiredPoints: requiredPoints,
          isUnlocked: isUnlocked,
          isCompleted: isCompleted,
        );

  factory QubeeModel.fromJson(Map<String, dynamic> json) {
    return QubeeModel(
      id: json['id'],
      letter: json['letter'],
      smallLetter: json['smallLetter'],
      latinEquivalent: json['latinEquivalent'],
      pronunciation: json['pronunciation'],
      soundPath: json['soundPath'],
      tracingPoints: List<Map<String, double>>.from(
        json['tracingPoints'].map((point) => {
          'x': point['x'].toDouble(),
          'y': point['y'].toDouble(),
        }),
      ),
      unlockedWords: List<String>.from(json['unlockedWords']),
      exampleSentence: json['exampleSentence'] ?? '',
      meaningOfSentence: json['meaningOfSentence'] ?? '',
      requiredPoints: json['requiredPoints'],
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'letter': letter,
      'smallLetter': smallLetter,
      'latinEquivalent': latinEquivalent,
      'pronunciation': pronunciation,
      'soundPath': soundPath,
      'tracingPoints': tracingPoints,
      'unlockedWords': unlockedWords,
      'exampleSentence': exampleSentence,
      'meaningOfSentence': meaningOfSentence,
      'requiredPoints': requiredPoints,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
    };
  }
}