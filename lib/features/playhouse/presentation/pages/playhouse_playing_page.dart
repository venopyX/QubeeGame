import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playhouse_provider.dart';
import '../widgets/video_player_widget.dart';

/// Page for playing videos with a full-screen player
class PlayhousePlayingPage extends StatefulWidget {
  /// Creates a PlayhousePlayingPage
  const PlayhousePlayingPage({super.key});

  @override
  State<PlayhousePlayingPage> createState() => _PlayhousePlayingPageState();
}

class _PlayhousePlayingPageState extends State<PlayhousePlayingPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayhouseProvider>(context);
    final video = provider.selectedVideo;

    if (video == null) {
      // Return to dashboard if no video is selected
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return VideoPlayerWidget(
      video: video,
      onComplete: () {
        // Play next video in queue
        provider.playNextVideo();
      },
      onClose: () {
        Navigator.of(context).pop();
      },
    );
  }
}
