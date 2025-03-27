import 'package:shared_preferences/shared_preferences.dart';
import '../models/video_model.dart';

/// Data source for retrieving and managing playhouse video data
class PlayhouseDatasource {
  /// Shared preferences key for storing the last watched video ID
  static const String _lastWatchedKey = 'last_watched_video_id';

  /// Retrieves a list of hardcoded video data for the MVP
  ///
  /// In a production app, this would be replaced with API calls
  List<VideoModel> getVideosFromData() {
    return [
      VideoModel(
        id: '1',
        title: 'Oromo Alphabet Song',
        thumbnailUrl: 'https://i.ytimg.com/vi/-qSzGoPnZHc/hqdefault.jpg',
        videoId: '-qSzGoPnZHc',
        description: 'Learn the Oromo alphabet through a catchy song',
        tags: ['song', 'alphabet', 'beginner'],
        category: 'Basics',
      ),
      VideoModel(
        id: '2',
        title: 'Qubee Afaan Oromoo Ijoollee Kaayyoo',
        thumbnailUrl: 'https://img.youtube.com/vi/GjyHiz-6wzA/hqdefault.jpg',
        videoId: 'GjyHiz-6wzA',
        description: 'Oromo letters(qubee) song with Ijoollee Kaayyoo',
        tags: ['song', 'letters', 'qubee'],
        category: 'Basics',
      ),
      VideoModel(
        id: '3',
        title: 'Qubee Afaan Oromoo Sagaleessuu',
        thumbnailUrl: 'https://i.ytimg.com/vi/b4ayeOsNbFo/hqdefault.jpg',
        videoId: 'b4ayeOsNbFo',
        description: 'Pronunciation of Oromic alphabets',
        tags: ['alphabets', 'pronunciation', 'beginner'],
        category: 'Basics',
      ),
      VideoModel(
        id: '4',
        title: 'Guyyoota Torbanii: Days of the Week in Afaan Oromoo',
        thumbnailUrl: 'https://i.ytimg.com/vi/WvzfdGMpYxI/hqdefault.jpg',
        videoId: 'WvzfdGMpYxI',
        description:
            'Learn how to say the days of the week in Afaan Oromoo with fun animations',
        tags: ['days', 'vocabulary', 'children'],
        category: 'Basics',
      ),
      VideoModel(
        id: '5',
        title: 'Obboleessakoo koo fi Qubee Afaan Oromoo',
        thumbnailUrl: 'https://i.ytimg.com/vi/e3fFfy9j-iM/hqdefault.jpg',
        videoId: 'e3fFfy9j-iM',
        description:
            'Fun and interactive tutorial for children learning basic Afaan Oromoo',
        tags: ['tutorial', 'basics', 'beginner'],
        category: 'Tutorials',
      ),
      VideoModel(
        id: '6',
        title: '"Gammachuu yoo qabaatte" - If you\'re happy and you know it',
        thumbnailUrl: 'https://i.ytimg.com/vi/FBX7D8Y3sfc/hqdefault.jpg',
        videoId: 'FBX7D8Y3sfc',
        description:
            'A colorful song teaching children different colors in Afaan Oromoo',
        tags: ['colors', 'song', 'children'],
        category: 'Songs',
      ),
      VideoModel(
        id: '7',
        title: 'Hibboo Afaan Oromoo: Riddles for Children',
        thumbnailUrl: 'https://i.ytimg.com/vi/Ey1UgCB-wP0/hqdefault.jpg',
        videoId: 'Ey1UgCB-wP0',
        description:
            'Fun riddles in Afaan Oromoo to challenge young minds and teach critical thinking',
        tags: ['riddles', 'thinking', 'interactive'],
        category: 'Games',
      ),
      VideoModel(
        id: '8',
        title: 'Oduu Durii: Leenca fi Hantuuta (Lion and Mouse)',
        thumbnailUrl: 'https://i.ytimg.com/vi/Ti-EmgaLjT4/hqdefault.jpg',
        videoId: 'Ti-EmgaLjT4',
        description:
            'A classic Oromo folk tale teaching children about friendship and kindness',
        tags: ['story', 'animals', 'folklore'],
        category: 'Stories',
      ),
      VideoModel(
        id: '9',
        title: 'Lakkoofsota 1-20: Counting Song in Afaan Oromoo',
        thumbnailUrl: 'https://i.ytimg.com/vi/qwVcSoA9jyQ/hqdefault.jpg',
        videoId: 'qwVcSoA9jyQ',
        description:
            'Learn to count from 1 to 20 in Afaan Oromoo with this catchy song for children',
        tags: ['numbers', 'counting', 'song'],
        category: 'Songs',
      ),
      VideoModel(
        id: '10',
        title: 'Tapha Qaamaa: Body Parts Song in Afaan Oromoo',
        thumbnailUrl: 'https://i.ytimg.com/vi/Z7uI-9yy2l4/hqdefault.jpg',
        videoId: 'Z7uI-9yy2l4',
        description:
            'Interactive song teaching children the names of body parts in Afaan Oromoo',
        tags: ['body', 'song', 'interactive'],
        category: 'Songs',
      ),
      VideoModel(
        id: '11',
        title: 'KOTTUU MAALOO Kids Song by HANA And MELAT',
        thumbnailUrl: 'https://i.ytimg.com/vi/nznmyg0dRhU/hqdefault.jpg',
        videoId: 'nznmyg0dRhU',
        description:
            'Learn the correct order of the Oromo alphabet with fun animations',
        tags: ['alphabet', 'literacy', 'beginner'],
        category: 'Basics',
      ),
      VideoModel(
        id: '12',
        title: 'Weedduu Aadaa: Traditional Oromo Children Songs',
        thumbnailUrl: 'https://i.ytimg.com/vi/Y9E1XQ9hubI/hqdefault.jpg',
        videoId: 'Y9E1XQ9hubI',
        description:
            'Collection of traditional Oromo songs for children to learn cultural heritage',
        tags: ['traditional', 'culture', 'songs'],
        category: 'Culture',
      ),
    ];
  }

  /// Retrieves a list of videos, simulating an API call
  Future<List<VideoModel>> getVideos() async {
    // Simulate network delay in MVP (would be a real API call in production)
    await Future.delayed(const Duration(seconds: 1));
    return getVideosFromData();
  }

  /// Gets the ID of the last watched video from local storage
  Future<String?> getLastWatchedVideoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastWatchedKey);
  }

  /// Saves the ID of the last watched video to local storage
  Future<void> saveLastWatchedVideoId(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastWatchedKey, videoId);
  }
}
