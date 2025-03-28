import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as mobile;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as web;
import '../../domain/entities/video.dart';

/// A widget that plays videos from YouTube
///
/// Handles both mobile and web platforms with appropriate player implementations
class VideoPlayerWidget extends StatefulWidget {
  /// The video to play
  final Video video;

  /// Callback triggered when the video completes playback
  final VoidCallback onComplete;

  /// Callback triggered when the user closes the player
  final VoidCallback onClose;

  /// Creates a VideoPlayerWidget
  const VideoPlayerWidget({
    super.key,
    required this.video,
    required this.onComplete,
    required this.onClose,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  /// Controller for the YouTube player (dynamic type to handle both web and mobile)
  dynamic _controller;

  /// Whether the player has been initialized
  bool _isInitialized = false;

  /// Whether to show the player controls overlay
  bool _showControls = true;

  /// Whether the video has finished playing
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Initialize web player (youtube_player_iframe)
      _controller = web.YoutubePlayerController.fromVideoId(
        videoId: widget.video.videoId,
        autoPlay: true,
        params: const web.YoutubePlayerParams(
          mute: false,
          showControls: false,
          showFullscreenButton: true,
          enableCaption: false,
        ),
      )..listen(_videoListenerWeb);
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Initialize mobile player (youtube_player_flutter)
      _controller = mobile.YoutubePlayerController(
        initialVideoId: widget.video.videoId,
        flags: const mobile.YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          hideControls: false,
          disableDragSeek: false,
          enableCaption: false,
        ),
      )..addListener(_videoListenerMobile);
    } else {
      throw UnsupportedError('This platform is not supported');
    }

    _initializeVideo();
  }

  /// Initializes the video player and sets up auto-hide for controls
  Future<void> _initializeVideo() async {
    setState(() {
      _isInitialized = true;
    });

    // Auto-hide controls after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  /// Listener for the mobile player (youtube_player_flutter)
  void _videoListenerMobile() {
    if (_controller.value.playerState == mobile.PlayerState.ended) {
      if (!_isFinished) {
        setState(() {
          _isFinished = true;
        });
        // Automatically move to the next video after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    }
  }

  /// Listener for the web player (youtube_player_iframe)
  void _videoListenerWeb(web.YoutubePlayerValue value) {
    if (value.playerState == web.PlayerState.ended) {
      if (!_isFinished) {
        setState(() {
          _isFinished = true;
        });
        // Automatically move to the next video after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            widget.onComplete();
          }
        });
      }
    }
  }

  /// Toggles play/pause state of the video
  void _togglePlayPause() {
    if (kIsWeb) {
      _controller.value.playerState == web.PlayerState.playing
          ? _controller.pauseVideo()
          : _controller.playVideo();
    } else {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    }
    setState(() {}); // Update UI for play/pause icon
  }

  /// Gets whether the video is currently playing
  bool _getIsPlaying() {
    if (kIsWeb) {
      return _controller.value.playerState == web.PlayerState.playing;
    } else {
      return _controller.value.isPlaying;
    }
  }

  /// Shows or hides the player controls overlay
  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Player
            Center(
              child:
                  _isInitialized
                      ? GestureDetector(
                        onTap: _toggleControls,
                        child:
                            kIsWeb
                                ? web.YoutubePlayer(
                                  controller: _controller,
                                  aspectRatio: 16 / 9,
                                )
                                : mobile.YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                  progressColors:
                                      const mobile.ProgressBarColors(
                                        playedColor: Colors.blue,
                                        handleColor: Colors.blueAccent,
                                      ),
                                ),
                      )
                      : const Center(child: CircularProgressIndicator()),
            ),

            // Controls Overlay
            if (_showControls)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleControls,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Column(
                      children: [
                        // Title bar and close button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.video.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: widget.onClose,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Play/pause button
                        IconButton(
                          icon: Icon(
                            _getIsPlaying()
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: Colors.white,
                            size: 64,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                        const Spacer(),
                        // Next video indicator
                        if (_isFinished)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: Text(
                              "Playing next video shortly...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _controller.close(); // For youtube_player_iframe
    } else {
      _controller.removeListener(_videoListenerMobile);
      _controller.dispose(); // For youtube_player_flutter
    }
    super.dispose();
  }
}
