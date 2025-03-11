class PlayhouseProgress {
  final int starsCollected;
  final int level;
  final List<String> completedVideos;
  final List<String> unlockedVideos;

  PlayhouseProgress({
    this.starsCollected = 0,
    this.level = 1,
    this.completedVideos = const [],
    this.unlockedVideos = const [],
  });

  PlayhouseProgress copyWith({
    int? starsCollected,
    int? level,
    List<String>? completedVideos,
    List<String>? unlockedVideos,
  }) {
    return PlayhouseProgress(
      starsCollected: starsCollected ?? this.starsCollected,
      level: level ?? this.level,
      completedVideos: completedVideos ?? this.completedVideos,
      unlockedVideos: unlockedVideos ?? this.unlockedVideos,
    );
  }
}