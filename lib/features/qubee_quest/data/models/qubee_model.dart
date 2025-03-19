import '../../domain/entities/qubee.dart';

class QubeeModel extends Qubee {
  QubeeModel({
    required super.id,
    required super.letter,
    required super.smallLetter,
    required super.latinEquivalent,
    required super.pronunciation,
    required super.soundPath,
    required super.tracingPoints,
    required super.unlockedWords,
    required super.exampleSentence,
    required super.meaningOfSentence,
    required super.requiredPoints,
    super.isUnlocked,
    super.isCompleted,
    super.tracingAccuracy,
    super.practiceCount,
  });

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
      tracingAccuracy: json['tracingAccuracy']?.toDouble() ?? 0.0,
      practiceCount: json['practiceCount'] ?? 0,
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
      'tracingAccuracy': tracingAccuracy,
      'practiceCount': practiceCount,
    };
  }
}