import '../../domain/entities/treasure.dart';

class TreasureModel extends Treasure {
  TreasureModel({
    required super.id,
    required super.qubeeLetterId,
    required super.word,
    required super.exampleSentence,
    required super.meaningOfSentence,
    super.isCollected,
  });

  factory TreasureModel.fromJson(Map<String, dynamic> json) {
    return TreasureModel(
      id: json['id'],
      qubeeLetterId: json['qubeeLetterId'],
      word: json['word'],
      exampleSentence: json['exampleSentence'] ?? '',
      meaningOfSentence: json['meaningOfSentence'] ?? '',
      isCollected: json['isCollected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qubeeLetterId': qubeeLetterId,
      'word': word,
      'exampleSentence': exampleSentence,
      'meaningOfSentence': meaningOfSentence,
      'isCollected': isCollected,
    };
  }
}