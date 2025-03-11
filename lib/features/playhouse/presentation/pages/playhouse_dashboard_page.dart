import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/video.dart';
import '../providers/playhouse_provider.dart';
import '../widgets/house_widget.dart';
import '../widgets/village_progress_widget.dart';
import 'playhouse_playing_page.dart';

class PlayhouseDashboardPage extends StatefulWidget {
  const PlayhouseDashboardPage({super.key});

  @override
  State<PlayhouseDashboardPage> createState() => _PlayhouseDashboardPageState();
}

class _PlayhouseDashboardPageState extends State<PlayhouseDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load videos when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayhouseProvider>().loadVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PlayhouseProvider>(
        builder: (context, provider, child) {
          if (provider.status == PlayhouseStatus.loading) {
            return _buildLoadingView();
          } else if (provider.status == PlayhouseStatus.error) {
            return _buildErrorView(provider.error!);
          } else if (provider.status == PlayhouseStatus.loaded) {
            return _buildDashboardView(provider);
          }
          
          // Initial state
          return _buildLoadingView();
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            onPressed: () {
              context.read<PlayhouseProvider>().loadVideos();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView(PlayhouseProvider provider) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildVillageHeader(provider),
        _buildHousesGrid(provider),
      ],
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange[700]!,
                Colors.orange[500]!,
              ],
            ),
          ),
        ),
        title: Text(
          'Oromo Playhouse',
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white),
          onPressed: () {
            _showInfoDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildVillageHeader(PlayhouseProvider provider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: VillageProgressWidget(
          progress: provider.progress,
        ),
      ),
    );
  }

  Widget _buildHousesGrid(PlayhouseProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final video = provider.videos[index];
            return HouseWidget(
              video: video,
              isCompleted: provider.isVideoCompleted(video.id),
              onTap: () {
                _openVideo(context, provider, video);
              },
            );
          },
          childCount: provider.videos.length,
        ),
      ),
    );
  }

  void _openVideo(
    BuildContext context,
    PlayhouseProvider provider,
    Video video,
  ) {
    provider.selectVideo(video);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PlayhousePlayingPage(),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Oromo Playhouse'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Welcome to the Oromo Playhouse!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'In this virtual village, you can explore different houses to '
                'watch educational videos in Afan Oromo language.',
              ),
              SizedBox(height: 16),
              Text(
                'How to Play:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Tap on unlocked houses to watch videos'),
              Text('• Complete videos to earn stars'),
              Text('• Play mini-games after videos for extra stars'),
              Text('• Unlock more houses as you collect stars'),
              SizedBox(height: 16),
              Text(
                'Learn Oromo language while having fun! Each house contains '
                'songs, stories, or cultural content to help you learn.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Got it!'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}