/// Entity representing a treasure (word) that can be collected
/// when learning Qubee letters
///
/// Each treasure is associated with a specific Qubee letter
class Treasure {
  /// Unique identifier for the treasure
  final int id;

  /// ID of the associated Qubee letter
  final int qubeeLetterId;

  /// The Oromo word representing this treasure
  final String word;

  /// Example sentence using the word
  final String exampleSentence;

  /// English translation of the example sentence
  final String meaningOfSentence;

  /// Whether the treasure has been collected by the user
  bool isCollected;

  /// Creates a new Treasure entity
  Treasure({
    required this.id,
    required this.qubeeLetterId,
    required this.word,
    required this.exampleSentence,
    required this.meaningOfSentence,
    this.isCollected = false,
  });
}
