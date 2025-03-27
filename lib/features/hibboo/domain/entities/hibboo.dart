/// Entity class representing a Hibboo (Oromo riddle)
///
/// Contains the riddle text, its answer, and difficulty level
class Hibboo {
  /// The text of the riddle
  final String text;
  
  /// The correct answer to the riddle
  final String answer;
  
  /// The difficulty level (1-5)
  final int level;

  /// Creates a new Hibboo instance
  const Hibboo({
    required this.text,
    required this.answer,
    required this.level,
  });
}