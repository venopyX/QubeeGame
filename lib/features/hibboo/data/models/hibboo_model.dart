class HibbooModel {
  final String text;
  final String answer;
  final int level;

  HibbooModel({
    required this.text,
    required this.answer,
    required this.level,
  });

  factory HibbooModel.fromJson(Map<String, dynamic> json) {
    return HibbooModel(
      text: json['text'],
      answer: json['answer'],
      level: json['level'] is int ? json['level'] : int.parse(json['level'].toString()), // Handle potential string values
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'answer': answer,
      'level': level,
    };
  }
}