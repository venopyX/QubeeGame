import '../../domain/entities/qubee.dart';

class QubeeModel extends Qubee {
  QubeeModel({
    required int id,
    required String letter,
    required String pronunciation,
    required String soundPath,
    required List<Map<String, double>> tracingPoints,
    required List<String> unlockedWords,
    required int requiredPoints,
  }) : super(
          id: id,
          letter: letter,
          pronunciation: pronunciation,
          soundPath: soundPath,
          tracingPoints: tracingPoints,
          unlockedWords: unlockedWords,
          requiredPoints: requiredPoints,
        );

  factory QubeeModel.fromJson(Map<String, dynamic> json) {
    return QubeeModel(
      id: json['id'],
      letter: json['letter'],
      pronunciation: json['pronunciation'],
      soundPath: json['soundPath'],
      tracingPoints: List<Map<String, double>>.from(
        json['tracingPoints'].map((point) => {
          'x': point['x'].toDouble(),
          'y': point['y'].toDouble(),
        }),
      ),
      unlockedWords: List<String>.from(json['unlockedWords']),
      requiredPoints: json['requiredPoints'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'letter': letter,
      'pronunciation': pronunciation,
      'soundPath': soundPath,
      'tracingPoints': tracingPoints,
      'unlockedWords': unlockedWords,
      'requiredPoints': requiredPoints,
    };
  }
}