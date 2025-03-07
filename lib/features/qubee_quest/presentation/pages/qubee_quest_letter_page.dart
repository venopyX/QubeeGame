import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/letter_tracing_widget.dart';
import '../widgets/celebration_overlay.dart';

class QubeeQuestLetterPage extends StatefulWidget {
  const QubeeQuestLetterPage({super.key});

  @override
  State<QubeeQuestLetterPage> createState() => _QubeeQuestLetterPageState();
}

class _QubeeQuestLetterPageState extends State<QubeeQuestLetterPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Play letter sound when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QubeeQuestProvider>().playLetterSound();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QubeeQuestProvider>(
        builder: (context, provider, _) {
          if (provider.currentLetter == null) {
            return const Center(child: Text('No letter selected'));
          }

          final letter = provider.currentLetter!;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue[50]!,
                      Colors.blue[100]!,
                    ],
                  ),
                ),
              ),

              // Main content
              SafeArea(
                child: Column(
                  children: [
                    // App bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: Text(
                              'Letter ${letter.letter}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.volume_up, color: Colors.blue[700]),
                            onPressed: () => provider.playLetterSound(),
                          ),
                        ],
                      ),
                    ),

                    // Letter display and pronunciation
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            letter.letter,
                            style: const TextStyle(
                              fontSize: 120,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Pronunciation: "${letter.pronunciation}"',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Instructions
                    Text(
                      provider.isTracingActive
                          ? 'Trace the letter by following the path'
                          : 'Tap the button below to start tracing',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tracing area or start button
                    Expanded(
                      child: provider.isTracingActive
                          ? LetterTracingWidget(
                              letter: letter,
                              onCompleted: () {
                                provider.completeTracing();
                                _animationController.forward(from: 0.0);
                              },
                            )
                          : Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  backgroundColor: Colors.blue[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () => provider.startTracing(),
                                child: Text(
                                  letter.isCompleted ? 'Trace Again' : 'Start Tracing',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    // Words that use this letter
                    if (!provider.isTracingActive && letter.unlockedWords.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber[200]!),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Words with ${letter.letter}:',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: letter.unlockedWords
                                  .map(
                                    (word) => Chip(
                                      label: Text(word),
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Success celebration overlay
              if (provider.hasCompletedTracing)
                CelebrationOverlay(
                  controller: _animationController,
                  onDone: () {
                    Navigator.of(context).pop();
                  },
                  treasureWord: letter.unlockedWords.isNotEmpty
                      ? letter.unlockedWords.first
                      : null,
                ),
            ],
          );
        },
      ),
    );
  }
}