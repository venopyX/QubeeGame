import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playhouse_provider.dart';
import '../widgets/video_player_widget.dart';
import '../widgets/word_matching_game_widget.dart';

class PlayhousePlayingPage extends StatefulWidget {
  const PlayhousePlayingPage({super.key});

  @override
  State<PlayhousePlayingPage> createState() => _PlayhousePlayingPageState();
}

class _PlayhousePlayingPageState extends State<PlayhousePlayingPage> {
  bool _showingGame = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayhouseProvider>(context);
    final video = provider.selectedVideo;

    if (video == null) {
      // Return to dashboard if no video is selected
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showingGame) {
      return WordMatchingGameWidget(
        onGameComplete: (stars) {
          provider.earnStars(stars);
          Navigator.of(context).pop();
        },
        onClose: () => Navigator.of(context).pop(),
      );
    } else {
      return VideoPlayerWidget(
        video: video,
        onComplete: () {
          provider.completeVideo(video.id);
          setState(() {
            _showingGame = true;
          });
        },
        onClose: () {
          provider.clearSelectedVideo();
          Navigator.of(context).pop();
        },
      );
    }
  }
}