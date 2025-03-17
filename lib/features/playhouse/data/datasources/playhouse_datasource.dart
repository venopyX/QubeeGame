import 'package:shared_preferences/shared_preferences.dart';
import '../models/video_model.dart';

class PlayhouseDatasource {
  static const String _lastWatchedKey = 'last_watched_video_id';

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
        category: 'Basics',
      ),
      VideoModel(
        id: '2',
        title: 'Oromo Folk Tale: Lion and Mouse',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'g3jCAyPai2Y', // Sample YouTube ID
        description: 'A classic Oromo folk tale about friendship',
        tags: ['story', 'animals', 'beginner'],
        category: 'Stories',
      ),
      VideoModel(
        id: '3',
        title: 'Counting in Afan Oromo',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'FTQbiNvZqaY', // Sample YouTube ID
        description: 'Learn how to count from 1 to 20 in Afan Oromo',
        tags: ['numbers', 'counting', 'beginner'],
        category: 'Basics',
      ),
      VideoModel(
        id: '4',
        title: 'Colors in Afan Oromo',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'JGwWNGJdvx8', // Sample YouTube ID
        description: 'Learn common colors in Afan Oromo',
        tags: ['colors', 'vocabulary', 'beginner'],
        category: 'Basics',
      ),
      VideoModel(
        id: '5',
        title: 'Oromo Traditional Dance',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'kJQP7kiw5Fk', // Sample YouTube ID
        description: 'Watch traditional Oromo dance performances',
        tags: ['culture', 'dance', 'intermediate'],
        category: 'Culture',
      ),
      VideoModel(
        id: '6',
        title: 'Oromo Cultural Stories',
        thumbnailUrl: 'https://via.placeholder.com/480x360',
        videoId: 'hT_nvWreIhg', // Sample YouTube ID
        description: 'Stories about Oromo cultural practices',
        tags: ['culture', 'story', 'advanced'],
        category: 'Culture',
      ),
    ];
  }

  Future<List<VideoModel>> getVideos() async {
    // In a real app, we would fetch from Firebase
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return getVideosFromData();
  }

  Future<String?> getLastWatchedVideoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastWatchedKey);
  }

  Future<void> saveLastWatchedVideoId(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastWatchedKey, videoId);
  }
}
