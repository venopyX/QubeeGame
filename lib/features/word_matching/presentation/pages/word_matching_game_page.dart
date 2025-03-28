import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/word_matching_provider.dart';
import '../widgets/word_card_widget.dart';
import '../widgets/stats_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/difficulty_dialog.dart';
import '../widgets/completion_view.dart';

/// Main page for the word matching game
///
/// Handles game flow from category selection to gameplay to completion
class WordMatchingGamePage extends StatefulWidget {
  /// Creates a WordMatchingGamePage
  const WordMatchingGamePage({super.key});

  @override
  State<WordMatchingGamePage> createState() => _WordMatchingGamePageState();
}

class _WordMatchingGamePageState extends State<WordMatchingGamePage> {
  /// ID of the currently selected word
  String? _selectedWordId;

  /// Current difficulty level (number of word pairs)
  int _currentDifficulty = 4;

  @override
  void initState() {
    super.initState();
    // Load word pairs when page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WordMatchingProvider>();
      provider.loadWordPairs();
    });
  }

  /// Handles back button behavior
  Future<bool> _onWillPop() async {
    final provider = Provider.of<WordMatchingProvider>(context, listen: false);

    // If we're playing or completed, go back to category selection instead of exiting
    if (provider.status == WordMatchingStatus.playing ||
        provider.status == WordMatchingStatus.completed) {
      provider.resetGame();
      return false; // Don't allow the app to pop
    }

    return true; // Allow normal back button behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Word Matching Game'),
          backgroundColor: Colors.purple.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: Consumer<WordMatchingProvider>(
            builder: (context, provider, child) {
              // Override back button behavior
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (provider.status == WordMatchingStatus.playing ||
                      provider.status == WordMatchingStatus.completed) {
                    provider.resetGame(); // Go back to category selection
                  } else {
                    Navigator.of(context).pop(); // Regular back button behavior
                  }
                },
              );
            },
          ),
          actions: [
            Consumer<WordMatchingProvider>(
              builder: (context, provider, child) {
                if (provider.status == WordMatchingStatus.playing) {
                  return IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Restart Game',
                    onPressed: () {
                      _showRestartConfirmationDialog(context, provider);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
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
                return CompletionView(
                  score: provider.score,
                  totalQuestions: provider.gameWordPairs.length,
                  stats: provider.stats,
                  onPlayNext: () => provider.startNewGame(_currentDifficulty),
                  onReplay: () => provider.replayCurrentGame(),
                  onChooseCategory: () => provider.resetGame(),
                );
              case WordMatchingStatus.initial:
                return _buildLoadingView();
            }
          },
        ),
      ),
    );
  }

  /// Builds the main game view for matching words
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
                  developer.log("Target card tapped: ${pair.id}");
                  if (_selectedWordId != null) {
                    // Check if selected word matches target
                    if (_selectedWordId == pair.id) {
                      developer.log(
                        "MATCH FOUND: $_selectedWordId matches ${pair.id}",
                      );
                      // Update matched status in the provider
                      setState(() {
                        matched[pair.id] = true;
                        provider.updateMatchedStatus(pair.id, true);
                        provider.incrementScore();
                        _selectedWordId = null;
                      });

                      // Check if all words are matched
                      if (provider.isAllMatched()) {
                        developer.log("ALL MATCHED - Completing game!");
                        provider.completeGame();
                      }
                    } else {
                      developer.log(
                        "NO MATCH: $_selectedWordId doesn't match ${pair.id}",
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Try again!'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
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
                    itemCount: provider.scrambledWordIds.length,
                    itemBuilder: (context, index) {
                      final wordId = provider.scrambledWordIds[index];
                      final pair = provider.getWordPairById(wordId);
                      final isMatched = matched[pair.id] ?? false;
                      final isSelected = _selectedWordId == pair.id;

                      if (isMatched) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          developer.log("Word tapped: ${pair.id}");
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

  /// Builds loading indicator view
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

  /// Builds error view with retry option
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

  /// Builds category selection view
  Widget _buildCategorySelectionView(WordMatchingProvider provider) {
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
                StatsCard(stats: provider.stats),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: CategorySelector(
            categories: provider.categories,
            selectedCategory: provider.selectedCategory,
            onCategorySelected: (category) {
              provider.selectCategory(category);
              _showDifficultyDialog(context, provider);
            },
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  /// Shows dialog for selecting difficulty
  void _showDifficultyDialog(
    BuildContext context,
    WordMatchingProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => DifficultyDialog(
            onDifficultySelected: (difficulty) {
              setState(() {
                _currentDifficulty = difficulty;
              });
              provider.startGame(difficulty);
            },
          ),
    );
  }

  /// Shows dialog explaining how to play
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

  /// Shows confirmation dialog for restarting the game
  void _showRestartConfirmationDialog(
    BuildContext context,
    WordMatchingProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Restart Game?'),
            content: const Text(
              'Are you sure you want to restart the game? Your current progress will be lost.',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Restart'),
                onPressed: () {
                  Navigator.of(context).pop();
                  provider.startGame(_currentDifficulty);
                },
              ),
            ],
          ),
    );
  }
}
