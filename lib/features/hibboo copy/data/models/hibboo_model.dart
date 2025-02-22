class HibbooModel {
  final String text;
  final String answer;
  final String stage;

  HibbooModel({
    required this.text,
    required this.answer,
    required this.stage,
  });

  factory HibbooModel.fromJson(Map<String, dynamic> json) {
    return HibbooModel(
      text: json['text'],
      answer: json['answer'],
      stage: json['stage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'answer': answer,
      'stage': stage,
    };
  }
}