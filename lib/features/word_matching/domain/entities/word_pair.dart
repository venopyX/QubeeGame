class WordPair {
  final String id;
  final String word;
  final String meaning;
  final String imageUrl;
  final String category;
  final int difficulty;

  WordPair({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imageUrl,
    required this.category,
    this.difficulty = 1,
  });
}