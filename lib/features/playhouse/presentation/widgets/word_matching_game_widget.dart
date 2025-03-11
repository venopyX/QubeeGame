import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';

class WordMatchingGameWidget extends StatefulWidget {
  final Function(int) onGameComplete;
  final VoidCallback onClose;

  const WordMatchingGameWidget({
    super.key,
    required this.onGameComplete,
    required this.onClose,
  });

  @override
  State<WordMatchingGameWidget> createState() => _WordMatchingGameWidgetState();
}

class _WordMatchingGameWidgetState extends State<WordMatchingGameWidget> {
  final List<WordPair> _pairs = [
    WordPair(word: 'bishaan', meaning: 'water', image: 'assets/water.png'),
    WordPair(word: 'aduu', meaning: 'sun', image: 'assets/sun.png'),
    WordPair(word: 'loon', meaning: 'cow', image: 'assets/cow.png'),
    WordPair(word: 'gaara', meaning: 'mountain', image: 'assets/mountain.png'),
  ];
  
  List<WordPair> _gamePairs = [];
  Map<String, bool> _matched = {};
  String? _draggedWord;
  int _score = 0;
  bool _gameCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Shuffle the list to make the game different each time
    _gamePairs = List.from(_pairs)..shuffle(Random());
    
    // Initialize match status
    _matched = {for (var pair in _gamePairs) pair.word: false};
    
    _score = 0;
    _gameCompleted = false;
  }

  void _checkGameCompletion() {
    if (_matched.values.every((matched) => matched)) {
      setState(() {
        _gameCompleted = true;
      });
      
      // Calculate stars based on score
      final stars = _score >= _gamePairs.length ? 2 : 1;
      
      // Delay to show completion animation
      Future.delayed(const Duration(seconds: 2), () {
        widget.onGameComplete(stars);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Matching Game'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onClose,
        ),
      ),
      body: _gameCompleted
          ? _buildCompletionView()
          : _buildGameView(),
    );
  }

  Widget _buildGameView() {
    return Column(
      children: [
        // Instructions
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: const Text(
            'Drag the Oromo words to match their pictures!',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Score display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Score: $_score',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Images section (targets)
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: _gamePairs.length,
            itemBuilder: (context, index) {
              final pair = _gamePairs[index];
              final isMatched = _matched[pair.word] ?? false;
              
              return DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.green.withOpacity(0.3)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isMatched
                            ? Colors.green
                            : Colors.grey.shade400,
                        width: isMatched ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image (placeholder in this example)
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              pair.image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                );
                              },
                            ),
                          ),
                        ),
                        
                        // English meaning
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              pair.meaning,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ),
                        
                        // Matched word
                        if (isMatched)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Text(
                              pair.word,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                onWillAcceptWithDetails: (data) {
                  // Only accept if this is the correct match and not already matched
                  return data == pair.word && !_matched[pair.word]!;
                },
                onAcceptWithDetails: (data) {
                  setState(() {
                    _matched[pair.word] = true;
                    _score += 1;
                  });
                  _checkGameCompletion();
                },
              ).animate()
                .fade(duration: 400.ms, delay: (100 * index).ms)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 400.ms,
                  delay: (100 * index).ms,
                  curve: Curves.easeOut,
                );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Words section (draggables)
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _gamePairs.length,
            itemBuilder: (context, index) {
              final pair = _gamePairs[index];
              final isMatched = _matched[pair.word] ?? false;
              
              if (isMatched) {
                // Return an empty container for matched words
                return const SizedBox(width: 10);
              }
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Draggable<String>(
                  data: pair.word,
                  feedback: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      pair.word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Text(
                      pair.word,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Text(
                      pair.word,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ),
              ).animate()
                .fadeIn(duration: 400.ms, delay: (200 + 100 * index).ms)
                .moveX(
                  begin: 50, 
                  end: 0, 
                  duration: 400.ms,
                  delay: (200 + 100 * index).ms,
                  curve: Curves.easeOut,
                );
            },
          ),
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ).animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1.0, 1.0),
              duration: 500.ms,
              curve: Curves.elasticOut,
            ),
          const SizedBox(height: 24),
          Text(
            'Game Completed!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ).animate()
            .fadeIn(delay: 300.ms, duration: 500.ms),
          const SizedBox(height: 16),
          Text(
            'You scored: $_score/${_gamePairs.length}',
            style: Theme.of(context).textTheme.titleLarge,
          ).animate()
            .fadeIn(delay: 500.ms, duration: 500.ms),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.home),
            label: const Text('Return to Village'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            onPressed: widget.onClose,
          ).animate()
            .fadeIn(delay: 800.ms, duration: 500.ms)
            .moveY(begin: 20, end: 0, delay: 800.ms, duration: 500.ms),
        ],
      ),
    );
  }
}

class WordPair {
  final String word;
  final String meaning;
  final String image;

  WordPair({
    required this.word,
    required this.meaning,
    required this.image,
  });
}