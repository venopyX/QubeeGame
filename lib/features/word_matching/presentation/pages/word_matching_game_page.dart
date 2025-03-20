import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/word_matching_provider.dart';
import '../widgets/word_card_widget.dart';

class WordMatchingGamePage extends StatefulWidget {
  const WordMatchingGamePage({super.key});

  @override
  State<WordMatchingGamePage> createState() => _WordMatchingGamePageState();
}

class _WordMatchingGamePageState extends State<WordMatchingGamePage> {
  String? _selectedWordId;

  @override
  void initState() {
    super.initState();
    // Load word pairs when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WordMatchingProvider>();
      provider.loadWordPairs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Matching Game'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<WordMatchingProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case WordMatchingStatus.loading:
              return _buildLoadingView();
            case WordMatchingStatus.error:
              return _buildErrorView(provider);
            case WordMatchingStatus.loaded:
              return _buildCategorySelectionView(provider);
            case WordMatchingStatus.playing:
              return _buildGameView(provider);
            case WordMatchingStatus.completed:
              return _buildCompletionView(provider);
            case WordMatchingStatus.initial:
              return _buildLoadingView();
          }
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading word pairs...',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(WordMatchingProvider provider) {
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
            provider.error ?? 'Unknown error',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade700),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            onPressed: () {
              provider.loadWordPairs();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelectionView(WordMatchingProvider provider) {
    final categories = provider.categories;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a Category',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Match Oromo words with their meanings',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                // Game statistics
                _buildStatsCard(provider),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= categories.length) return null;

              final category = categories[index];
              final isSelected = category == provider.selectedCategory;

              String displayName =
                  category == 'all'
                      ? 'All Categories'
                      : '${category[0].toUpperCase()}${category.substring(1)}';

              IconData icon;
              Color color;

              switch (category) {
                case 'animals':
                  icon = Icons.pets;
                  color = Colors.brown;
                  break;
                case 'nature':
                  icon = Icons.landscape;
                  color = Colors.green;
                  break;
                case 'food':
                  icon = Icons.restaurant;
                  color = Colors.orange;
                  break;
                case 'colors':
                  icon = Icons.palette;
                  color = Colors.blue;
                  break;
                case 'all':
                default:
                  icon = Icons.category;
                  color = Colors.purple;
              }

              return GestureDetector(
                onTap: () {
                  provider.selectCategory(category);
                  _showDifficultyDialog(context, provider);
                },
                child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            isSelected
                                ? Border.all(color: color, width: 2)
                                : Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 48, color: color),
                          const SizedBox(height: 12),
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 400.ms,
                      delay: (100 * index).ms,
                    ),
              );
            }, childCount: categories.length),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildStatsCard(WordMatchingProvider provider) {
    final stats = provider.stats;
    final gamesPlayed = stats['gamesPlayed'] ?? 0;
    final highestScore = stats['highestScore'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade700, Colors.purple.shade500],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Statistics',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                icon: Icons.videogame_asset,
                value: '$gamesPlayed',
                label: 'Games Played',
              ),
              _buildStatItem(
                icon: Icons.emoji_events,
                value: '$highestScore',
                label: 'Highest Score',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDifficultyDialog(
    BuildContext context,
    WordMatchingProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Choose Difficulty'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDifficultyOption(
                  context,
                  difficulty: 4,
                  name: 'Easy',
                  description: '4 word pairs',
                  provider: provider,
                ),
                const SizedBox(height: 12),
                _buildDifficultyOption(
                  context,
                  difficulty: 6,
                  name: 'Medium',
                  description: '6 word pairs',
                  provider: provider,
                ),
                const SizedBox(height: 12),
                _buildDifficultyOption(
                  context,
                  difficulty: 8,
                  name: 'Hard',
                  description: '8 word pairs',
                  provider: provider,
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDifficultyOption(
    BuildContext context, {
    required int difficulty,
    required String name,
    required String description,
    required WordMatchingProvider provider,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        provider.startGame(difficulty);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$difficulty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade800,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameView(WordMatchingProvider provider) {
    final gamePairs = provider.gameWordPairs;
    final matched = provider.matched;

    return Column(
      children: [
        // Score and info bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.purple.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'Score: ${provider.score}/${gamePairs.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                icon: const Icon(Icons.help_outline),
                label: const Text('How to Play'),
                onPressed: () => _showHowToPlayDialog(context),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Match the Oromo words with their meanings',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 16),

        // Image cards (meaning targets)
        Expanded(
          flex: 3,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: gamePairs.length,
            itemBuilder: (context, index) {
              final pair = gamePairs[index];
              final isMatched = matched[pair.id] ?? false;

              return WordCardWidget(
                wordPair: pair,
                isMatched: isMatched,
                isTarget: true, // Image card
                onTap: (_) {
                  if (_selectedWordId != null) {
                    if (_selectedWordId == pair.id) {
                      setState(() {
                        matched[pair.id] = true;
                        provider.attemptMatch(pair.id);
                        _selectedWordId = null;
                      });
                    } else {
                      // Wrong match
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Try again!'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      setState(() {
                        _selectedWordId = null;
                      });
                    }
                  }
                },
              );
            },
          ),
        ),

        // Word selection section
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Oromo Words:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2.5,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: gamePairs.length,
                    itemBuilder: (context, index) {
                      final pair = gamePairs[index];
                      final isMatched = matched[pair.id] ?? false;
                      final isSelected = _selectedWordId == pair.id;

                      if (isMatched) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedWordId = isSelected ? null : pair.id;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Colors.purple.shade200
                                    : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? Colors.purple.shade800
                                      : Colors.orange.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              pair.word,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    isSelected
                                        ? Colors.purple.shade800
                                        : Colors.orange.shade800,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionView(WordMatchingProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 80,
          ).animate().scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.0, 1.0),
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          const SizedBox(height: 24),
          Text(
            'Game Completed!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: 16),
          Text(
            'You matched ${provider.score}/${provider.gameWordPairs.length} words correctly',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 500.ms, duration: 500.ms),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.grey.shade800,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Exit Game'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Play Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  provider.resetGame();
                },
              ),
            ],
          ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
        ],
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('How to Play'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '1. Select an Oromo word from the bottom section',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '2. Tap on the matching image/meaning card',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '3. If it\'s correct, you\'ll earn a point',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Text(
                  '4. Match all words to complete the game',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Got It!'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}
