import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/video.dart';
import '../providers/playhouse_provider.dart';
import '../widgets/video_card_widget.dart';
import 'playhouse_playing_page.dart';

class PlayhouseDashboardPage extends StatefulWidget {
  const PlayhouseDashboardPage({super.key});

  @override
  State<PlayhouseDashboardPage> createState() => _PlayhouseDashboardPageState();
}

class _PlayhouseDashboardPageState extends State<PlayhouseDashboardPage> {
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
        _buildSearchAndFilter(provider),
        _buildVideosGrid(provider),
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
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (value) {
                provider.search(value);
              },
            ),
            SizedBox(height: 16),
            // Category filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text('All'),
                    selected: provider.selectedCategory == null,
                    onSelected: (_) {
                      provider.selectCategory(null);
                    },
                  ),
                  SizedBox(width: 8),
                  ...provider.availableCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(category),
                        selected: provider.selectedCategory == category,
                        onSelected: (_) {
                          provider.selectCategory(
                            provider.selectedCategory == category ? null : category
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosGrid(PlayhouseProvider provider) {
    if (provider.videos.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.video_library, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No videos found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final video = provider.videos[index];
            return VideoCardWidget(
              video: video,
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
              Text('• Learn Oromo language and culture through engaging videos'),
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