import '../../domain/entities/treasure.dart';

/// Data model for Treasure with JSON serialization capabilities
class TreasureModel extends Treasure {
  /// Creates a TreasureModel with the provided values
  TreasureModel({
    required super.id,
    required super.qubeeLetterId,
    required super.word,
    required super.exampleSentence,
    required super.meaningOfSentence,
    super.isCollected,
  });

  /// Creates a TreasureModel from a JSON map
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

  /// Converts the model to a JSON map
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
