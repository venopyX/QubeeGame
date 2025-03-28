import '../../domain/entities/hibboo.dart';

/// Data model class for Hibboo entities
///
/// Extends the base [Hibboo] entity with serialization capabilities
class HibbooModel extends Hibboo {
  /// Creates a new HibbooModel instance
  const HibbooModel({
    required super.text,
    required super.answer,
    required super.level,
  });

  /// Creates a HibbooModel from JSON data
  factory HibbooModel.fromJson(Map<String, dynamic> json) {
    return HibbooModel(
      text: json['text'],
      answer: json['answer'],
      level:
          json['level'] is int
              ? json['level']
              : int.parse(json['level'].toString()),
    );
  }

  /// Converts this HibbooModel to a JSON map
  Map<String, dynamic> toJson() {
    return {'text': text, 'answer': answer, 'level': level};
  }
}
