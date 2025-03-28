/// Entity class representing a word pair for matching games
///
/// Contains the Oromo word, its meaning, and associated metadata
class WordPair {
  /// Unique identifier for the word pair
  final String id;
  
  /// The Oromo word
  final String word;
  
  /// The English meaning of the word
  final String meaning;
  
  /// URL to an image representing the word
  final String imageUrl;
  
  /// Category the word belongs to (e.g., animals, colors)
  final String category;
  
  /// Difficulty level of the word (1 = easy, 2 = medium, etc.)
  final int difficulty;

  /// Creates a new WordPair
  const WordPair({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imageUrl,
    required this.category,
    this.difficulty = 1,
  });
}