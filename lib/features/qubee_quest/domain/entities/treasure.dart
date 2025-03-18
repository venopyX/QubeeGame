class Treasure {
  final int id;
  final int qubeeLetterId;
  final String word;
  final String exampleSentence;
  final String meaningOfSentence;
  bool isCollected;
  
  Treasure({
    required this.id,
    required this.qubeeLetterId,
    required this.word,
    required this.exampleSentence,
    required this.meaningOfSentence,
    this.isCollected = false,
  });
}