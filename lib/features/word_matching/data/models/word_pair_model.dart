import '../../domain/entities/word_pair.dart';

/// Data model for word pairs with JSON serialization capabilities
class WordPairModel extends WordPair {
  /// Creates a new WordPairModel
  const WordPairModel({
    required super.id,
    required super.word,
    required super.meaning,
    required super.imageUrl,
    required super.category,
    super.difficulty,
  });

  /// Creates a WordPairModel from a JSON object
  factory WordPairModel.fromJson(Map<String, dynamic> json) {
    return WordPairModel(
      id: json['id'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }

  /// Converts this model to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'imageUrl': imageUrl,
      'category': category,
      'difficulty': difficulty,
    };
  }
}
