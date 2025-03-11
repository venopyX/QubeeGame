import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/video_model.dart';
import '../models/playhouse_progress_model.dart';

class PlayhouseDatasource {
  static const String _progressKey = 'playhouse_progress';
  
  // For the MVP, we'll use hardcoded video data
  // In a real implementation, this would come from Firebase
  List<VideoModel> getVideosFromData() {
    return [
      VideoModel(
        id: '1',
        title: 'Oromo Alphabet Song',
        thumbnailUrl: 'https://i.ytimg.com/vi/-qSzGoPnZHc/hq720.jpg',
        videoId: '-qSzGoPnZHc',
        description: 'Learn the Oromo alphabet through a catchy song',
        tags: ['song', 'alphabet', 'beginner'],
        isUnlocked: true,
      ),
      VideoModel(
        id: '2',
        title: 'Oromo Folk Tale: Lion and Mouse',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'g3jCAyPai2Y', // Sample YouTube ID
        description: 'A classic Oromo folk tale about friendship',
        tags: ['story', 'animals', 'beginner'],
        isUnlocked: true,
      ),
      VideoModel(
        id: '3',
        title: 'Counting in Afan Oromo',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'FTQbiNvZqaY', // Sample YouTube ID
        description: 'Learn how to count from 1 to 20 in Afan Oromo',
        tags: ['numbers', 'counting', 'beginner'],
        isUnlocked: false,
      ),
      VideoModel(
        id: '4',
        title: 'Colors in Afan Oromo',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'JGwWNGJdvx8', // Sample YouTube ID
        description: 'Learn common colors in Afan Oromo',
        tags: ['colors', 'vocabulary', 'beginner'],
        isUnlocked: false,
      ),
      VideoModel(
        id: '5',
        title: 'Oromo Traditional Dance',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'kJQP7kiw5Fk', // Sample YouTube ID
        description: 'Watch traditional Oromo dance performances',
        tags: ['culture', 'dance', 'intermediate'],
        isUnlocked: false,
      ),
      VideoModel(
        id: '6',
        title: 'Oromo Cultural Stories',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'hT_nvWreIhg', // Sample YouTube ID
        description: 'Stories about Oromo cultural practices',
        tags: ['culture', 'story', 'advanced'],
        isUnlocked: false,
      ),
    ];
  }

  Future<List<VideoModel>> getVideos() async {
    // In a real app, we would fetch from Firebase
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return getVideosFromData();
  }

  Future<PlayhouseProgressModel> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? progressJson = prefs.getString(_progressKey);
    
    if (progressJson == null) {
      // Initial progress with first two videos unlocked
      return PlayhouseProgressModel(
        unlockedVideos: ['1', '2'],
      );
    }
    
    return PlayhouseProgressModel.fromJson(json.decode(progressJson));
  }

  Future<void> saveProgress(PlayhouseProgressModel progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, json.encode(progress.toJson()));
  }

  Future<void> markVideoCompleted(String videoId) async {
    final progress = await getProgress();
    
    if (!progress.completedVideos.contains(videoId)) {
      var updatedProgress = PlayhouseProgressModel(
        starsCollected: progress.starsCollected + 1, // Award 1 star for completing a video
        level: progress.level,
        completedVideos: [...progress.completedVideos, videoId],
        unlockedVideos: progress.unlockedVideos,
      );
      
      // Check if we should unlock a new video
      if (updatedProgress.starsCollected % 3 == 0) {
        // Unlock next video based on current completed count
        final allVideos = getVideosFromData();
        for (final video in allVideos) {
          if (!updatedProgress.unlockedVideos.contains(video.id)) {
            updatedProgress = PlayhouseProgressModel(
              starsCollected: updatedProgress.starsCollected,
              level: updatedProgress.level,
              completedVideos: updatedProgress.completedVideos,
              unlockedVideos: [...updatedProgress.unlockedVideos, video.id],
            );
            break;
          }
        }
      }
      
      await saveProgress(updatedProgress);
    }
  }

  Future<void> addStars(int count) async {
    final progress = await getProgress();
    final updatedProgress = PlayhouseProgressModel(
      starsCollected: progress.starsCollected + count,
      level: progress.level,
      completedVideos: progress.completedVideos,
      unlockedVideos: progress.unlockedVideos,
    );
    await saveProgress(updatedProgress);
  }
}