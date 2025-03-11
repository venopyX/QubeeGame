import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as mobile;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as web;
import '../../domain/entities/video.dart';

class VideoPlayerWidget extends StatefulWidget {
  final Video video;
  final VoidCallback onComplete;
  final VoidCallback onClose;

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
  dynamic _controller; // Dynamic type to hold either controller
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Web: Use youtube_player_iframe
      _controller = web.YoutubePlayerController.fromVideoId(
        videoId: widget.video.videoId,
        autoPlay: true,
        params: const web.YoutubePlayerParams(
          mute: false,
          showControls: false, // We'll implement custom controls
          showFullscreenButton: true,
          enableCaption: false,
        ),
      )..listen(_videoListenerWeb);
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Mobile: Use youtube_player_flutter
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

  // Listener for mobile (youtube_player_flutter)
  void _videoListenerMobile() {
    if (_controller.value.playerState == mobile.PlayerState.ended) {
      if (!_isFinished) {
        setState(() {
          _isFinished = true;
          _showControls = true;
        });
      }
    }
  }

  // Listener for web (youtube_player_iframe)
  void _videoListenerWeb(web.YoutubePlayerValue value) {
    if (value.playerState == web.PlayerState.ended) {
      if (!_isFinished) {
        setState(() {
          _isFinished = true;
          _showControls = true;
        });
      }
    }
  }

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

  bool _getIsPlaying() {
    if (kIsWeb) {
      return _controller.value.playerState == web.PlayerState.playing;
    } else {
      return _controller.value.isPlaying;
    }
  }

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
            Center(
              child: _isInitialized
                  ? GestureDetector(
                      onTap: _toggleControls, // Correct reference to _toggleControls
                      child: kIsWeb
                          ? web.YoutubePlayer(
                              controller: _controller,
                              aspectRatio: 16 / 9,
                            )
                          : mobile.YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Colors.blue,
                              progressColors: const mobile.ProgressBarColors(
                                playedColor: Colors.blue,
                                handleColor: Colors.blueAccent,
                              ),
                            ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
            if (_showControls)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleControls, // Correct reference to _toggleControls
                  child: Container(
                    color: Colors.black.withAlpha((0.4 * 255).toInt()),
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                ),
              ),
            if (_isFinished)
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle),
                    label: const Text("I've Watched It!"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: widget.onComplete,
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