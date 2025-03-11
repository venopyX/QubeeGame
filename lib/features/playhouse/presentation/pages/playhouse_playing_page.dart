import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playhouse_provider.dart';
import '../widgets/video_player_widget.dart';

class PlayhousePlayingPage extends StatefulWidget {
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return VideoPlayerWidget(
      video: video,
      onComplete: () {
        provider.completeVideo(video.id);
        provider.clearSelectedVideo();
        Navigator.of(context).pop();
      },
      onClose: () {
        provider.clearSelectedVideo();
        Navigator.of(context).pop();
      },
    );
  }
}