import 'package:flutter/material.dart';
import '../../domain/entities/video.dart';
import '../../domain/entities/playhouse_progress.dart';
import '../../domain/usecases/get_videos.dart';
import '../../domain/usecases/update_progress.dart';

enum PlayhouseStatus { initial, loading, loaded, error }

class PlayhouseProvider extends ChangeNotifier {
  final GetVideos getVideos;
  final UpdateProgress updateProgress;

  PlayhouseStatus _status = PlayhouseStatus.initial;
  List<Video> _videos = [];
  PlayhouseProgress _progress = PlayhouseProgress();
  String? _error;
  Video? _selectedVideo;

  PlayhouseProvider(this.getVideos, this.updateProgress);

  PlayhouseStatus get status => _status;
  List<Video> get videos => _videos;
  PlayhouseProgress get progress => _progress;
  String? get error => _error;
  Video? get selectedVideo => _selectedVideo;

  Future<void> loadVideos() async {
    _status = PlayhouseStatus.loading;
    notifyListeners();

    try {
      final videos = await getVideos();
      final progress = await updateProgress.getProgress();
      
      _videos = videos.map((video) {
        return Video(
          id: video.id,
          title: video.title,
          thumbnailUrl: video.thumbnailUrl,
          videoId: video.videoId,
          description: video.description,
          tags: video.tags,
          isUnlocked: progress.unlockedVideos.contains(video.id),
        );
      }).toList();
      
      _progress = progress;
      _status = PlayhouseStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = PlayhouseStatus.error;
    }
    
    notifyListeners();
  }

  void selectVideo(Video video) {
    _selectedVideo = video;
    notifyListeners();
  }

  Future<void> completeVideo(String videoId) async {
    try {
      await updateProgress.markVideoCompleted(videoId);
      await loadVideos(); // Reload to get updated progress
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> earnStars(int count) async {
    try {
      await updateProgress.addStars(count);
      final progress = await updateProgress.getProgress();
      _progress = progress;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isVideoUnlocked(String videoId) {
    return _progress.unlockedVideos.contains(videoId);
  }

  bool isVideoCompleted(String videoId) {
    return _progress.completedVideos.contains(videoId);
  }

  void clearSelectedVideo() {
    _selectedVideo = null;
    notifyListeners();
  }
}