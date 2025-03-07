class Land {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final List<int> letterIds;
  bool isUnlocked;
  final int requiredPoints;

  Land({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.letterIds,
    required this.isUnlocked,
    required this.requiredPoints,
  });
}