import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/video.dart';
import '../providers/playhouse_provider.dart';
import '../widgets/video_card_widget.dart';
import '../widgets/category_filter.dart';
import '../widgets/empty_videos_indicator.dart';
import 'playhouse_playing_page.dart';

/// Dashboard page displaying available videos in a grid
///
/// Allows searching and filtering videos by category
class PlayhouseDashboardPage extends StatefulWidget {
  /// Creates a PlayhouseDashboardPage
  const PlayhouseDashboardPage({super.key});

  @override
  State<PlayhouseDashboardPage> createState() => _PlayhouseDashboardPageState();
}

class _PlayhouseDashboardPageState extends State<PlayhouseDashboardPage> {
  /// Controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load videos when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayhouseProvider>().loadVideos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  /// Builds a loading indicator view
  Widget _buildLoadingView() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds an error view with retry option
  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700),
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

  /// Builds the main dashboard view with search, filters and video grid
  Widget _buildDashboardView(PlayhouseProvider provider) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        _buildSearchAndFilter(provider),
        provider.videos.isEmpty
            ? const EmptyVideosIndicator()
            : _buildVideosGrid(provider),
      ],
    );
  }

  /// Builds the app bar with gradient background
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
              colors: [Colors.orange[700]!, Colors.orange[500]!],
            ),
          ),
        ),
        title: Text(
          'Oromo Playhouse',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
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

  /// Builds search field and category filter chips
  Widget _buildSearchAndFilter(PlayhouseProvider provider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search videos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (value) {
                provider.search(value);
              },
            ),
            const SizedBox(height: 16),
            // Category filter chips
            CategoryFilter(
              categories: provider.availableCategories,
              selectedCategory: provider.selectedCategory,
              onCategorySelected: (category) {
                provider.selectCategory(category);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a grid of video cards
  Widget _buildVideosGrid(PlayhouseProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final video = provider.videos[index];
          return VideoCardWidget(
            video: video,
            onTap: () {
              _openVideo(context, provider, video);
            },
          );
        }, childCount: provider.videos.length),
      ),
    );
  }

  /// Opens a video for playback
  void _openVideo(
    BuildContext context,
    PlayhouseProvider provider,
    Video video,
  ) {
    provider.selectVideo(video);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PlayhousePlayingPage()));
  }

  /// Shows an info dialog about the playhouse feature
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                    'This app features educational videos in Afan Oromo language. '
                    'Browse, search, and watch videos to learn Oromo language and culture.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Features:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Search for videos by title or description'),
                  Text('• Filter videos by category'),
                  Text('• Automatic playback of the next video in queue'),
                  Text(
                    '• Learn Oromo language and culture through engaging videos',
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
