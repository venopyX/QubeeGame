class Treasure {
  final int id;
  final String word;
  final String meaning;
  final String imagePath;
  final int qubeeLetterId;
  bool isCollected;

  Treasure({
    required this.id,
    required this.word,
    required this.meaning,
    required this.imagePath,
    required this.qubeeLetterId,
    this.isCollected = false,
  });
}