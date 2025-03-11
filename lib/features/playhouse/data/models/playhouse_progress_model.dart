import '../../domain/entities/playhouse_progress.dart';

class PlayhouseProgressModel extends PlayhouseProgress {
  PlayhouseProgressModel({
    super.starsCollected,
    super.level,
    super.completedVideos,
    super.unlockedVideos,
  });

  factory PlayhouseProgressModel.fromJson(Map<String, dynamic> json) {
    return PlayhouseProgressModel(
      starsCollected: json['starsCollected'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      completedVideos: (json['completedVideos'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      unlockedVideos:
          (json['unlockedVideos'] as List?)?.map((e) => e as String).toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'starsCollected': starsCollected,
      'level': level,
      'completedVideos': completedVideos,
      'unlockedVideos': unlockedVideos,
    };
  }
}