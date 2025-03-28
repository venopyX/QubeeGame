import 'package:flutter/material.dart';
import '../../domain/entities/video.dart';
import '../../domain/usecases/get_videos.dart';
import '../../domain/usecases/track_video_progress.dart';

/// Status of the playhouse data loading process
enum PlayhouseStatus {
  /// Initial state, no data loaded yet
  initial,

  /// Data is currently loading
  loading,

  /// Data has been loaded successfully
  loaded,

  /// Error occurred during loading
  error,
}

/// Provider for managing playhouse state including videos and playback
class PlayhouseProvider extends ChangeNotifier {
  /// Use case for retrieving videos
  final GetVideos getVideos;

  /// Use case for tracking video playback progress
  final TrackVideoProgress trackVideoProgress;

  /// Current status of the data loading process
  PlayhouseStatus _status = PlayhouseStatus.initial;

  /// List of all available videos
  List<Video> _allVideos = [];

  /// List of videos after filtering
  List<Video> _filteredVideos = [];

  /// Error message if loading failed
  String? _error;

  /// Currently selected video for playback
  Video? _selectedVideo;

  /// Current search query for filtering videos
  String _searchQuery = '';

  /// Currently selected category for filtering videos
  String? _selectedCategory;

  /// List of all available unique categories
  List<String> _availableCategories = [];

  /// Creates a PlayhouseProvider with required use cases
  PlayhouseProvider(this.getVideos, this.trackVideoProgress);

  /// Current status of data loading
  PlayhouseStatus get status => _status;

  /// Currently available videos (filtered)
  List<Video> get videos => _filteredVideos;

  /// List of all available categories
  List<String> get availableCategories => _availableCategories;

  /// Currently selected category filter
  String? get selectedCategory => _selectedCategory;

  /// Current search query
  String get searchQuery => _searchQuery;

  /// Error message if loading failed
  String? get error => _error;

  /// Currently selected video for playback
  Video? get selectedVideo => _selectedVideo;

  /// Loads the list of available videos
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

  /// Selects a video for playback
  void selectVideo(Video video) {
    _selectedVideo = video;
    trackVideoProgress.saveLastWatchedVideoId(video.id);
    notifyListeners();
  }

  /// Advances to the next video in the filtered list
  Future<void> playNextVideo() async {
    if (_selectedVideo == null || _filteredVideos.isEmpty) return;

    int currentIndex = _filteredVideos.indexWhere(
      (v) => v.id == _selectedVideo!.id,
    );
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

  /// Filters videos by search query
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filters videos by category
  void selectCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// Applies both search and category filters to the video list
  void _applyFilters() {
    _filteredVideos = _allVideos;

    // Apply category filter if selected
    if (_selectedCategory != null) {
      _filteredVideos =
          _filteredVideos
              .where((video) => video.category == _selectedCategory)
              .toList();
    }

    // Apply search filter if query exists
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      _filteredVideos =
          _filteredVideos.where((video) {
            return video.title.toLowerCase().contains(query) ||
                video.description.toLowerCase().contains(query) ||
                video.tags.any((tag) => tag.toLowerCase().contains(query));
          }).toList();
    }
  }

  /// Clears the currently selected video
  void clearSelectedVideo() {
    _selectedVideo = null;
    notifyListeners();
  }
}
