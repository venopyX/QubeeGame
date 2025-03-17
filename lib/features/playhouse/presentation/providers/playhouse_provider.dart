import 'package:flutter/material.dart';
import '../../domain/entities/video.dart';
import '../../domain/usecases/get_videos.dart';
import '../../domain/usecases/track_video_progress.dart';

enum PlayhouseStatus { initial, loading, loaded, error }

class PlayhouseProvider extends ChangeNotifier {
  final GetVideos getVideos;
  final TrackVideoProgress trackVideoProgress;

  PlayhouseStatus _status = PlayhouseStatus.initial;
  List<Video> _allVideos = [];
  List<Video> _filteredVideos = [];
  String? _error;
  Video? _selectedVideo;
  String _searchQuery = '';
  String? _selectedCategory;
  List<String> _availableCategories = [];

  PlayhouseProvider(this.getVideos, this.trackVideoProgress);

  PlayhouseStatus get status => _status;
  List<Video> get videos => _filteredVideos;
  List<String> get availableCategories => _availableCategories;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String? get error => _error;
  Video? get selectedVideo => _selectedVideo;

  Future<void> loadVideos() async {
    _status = PlayhouseStatus.loading;
    notifyListeners();

    try {
      final videos = await getVideos();
      _allVideos = videos;
      
      // Extract unique categories
      final categorySet = <String>{};
      for (var video in videos) {
        if (video.category != null) {
          categorySet.add(video.category!);
        }
      }
      _availableCategories = categorySet.toList()..sort();
      
      _applyFilters(); // Apply any existing filters
      _status = PlayhouseStatus.loaded;
    } catch (e) {
      _error = e.toString();
      _status = PlayhouseStatus.error;
    }
    
    notifyListeners();
  }

  void selectVideo(Video video) {
    _selectedVideo = video;
    trackVideoProgress.saveLastWatchedVideoId(video.id);
    notifyListeners();
  }

  Future<void> playNextVideo() async {
    if (_selectedVideo == null || _filteredVideos.isEmpty) return;
    
    int currentIndex = _filteredVideos.indexWhere((v) => v.id == _selectedVideo!.id);
    if (currentIndex == -1) {
      // Current video not in filtered list, play first
      selectVideo(_filteredVideos[0]);
      return;
    }
    
    int nextIndex = currentIndex + 1;
    // If we're at the end, loop back to the beginning
    if (nextIndex >= _filteredVideos.length) {
      nextIndex = 0;
    }
    
    selectVideo(_filteredVideos[nextIndex]);
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredVideos = _allVideos;
    
    // Apply category filter if selected
    if (_selectedCategory != null) {
      _filteredVideos = _filteredVideos
          .where((video) => video.category == _selectedCategory)
          .toList();
    }
    
    // Apply search filter if query exists
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredVideos = _filteredVideos.where((video) {
        return video.title.toLowerCase().contains(query) ||
               video.description.toLowerCase().contains(query) ||
               video.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }
  }

  void clearSelectedVideo() {
    _selectedVideo = null;
    notifyListeners();
  }
}