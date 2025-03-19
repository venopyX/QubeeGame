import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/letter_tracing_widget.dart';
import '../widgets/celebration_overlay.dart';

class QubeeQuestLetterPage extends StatefulWidget {
  final int letterId;

  const QubeeQuestLetterPage({required this.letterId, super.key});

  @override
  State<QubeeQuestLetterPage> createState() => _QubeeQuestLetterPageState();
}

class _QubeeQuestLetterPageState extends State<QubeeQuestLetterPage>
    with SingleTickerProviderStateMixin {
  bool _showCelebration = false;
  double _accuracy = 0.0;
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QubeeQuestProvider>(context, listen: false);
      provider.selectLetter(widget.letterId);

      provider.playLetterSound();
    });

    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void _handleLetterCompleted(double accuracy, double pathCoverage) {
    final provider = Provider.of<QubeeQuestProvider>(context, listen: false);
    provider.completeCurrentLetter(accuracy, pathCoverage);

    // Only show celebration if path coverage is above 90%
    if (pathCoverage >= 0.9) {
      provider.playSound('assets/audio/success.mp3');

      setState(() {
        _showCelebration = true;
      });
    } else {
      // Show a toast or snackbar instead for lower path coverage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Keep practicing! Try to trace more of the letter (${(pathCoverage * 100).toInt()}% covered)',
            style: const TextStyle(fontSize: 14),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _handleAccuracyChanged(double accuracy) {
    _accuracy = accuracy;
  }

  void _handleCelebrationDone() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QubeeQuestProvider>(
      builder: (context, provider, _) {
        final currentLetter = provider.currentLetter;

        if (currentLetter == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final treasure = provider.getTreasureForLetter(currentLetter.id);
        final treasureWord = treasure?.word;

        return Scaffold(
          appBar: AppBar(
            title: Text('Learn Letter ${currentLetter.latinEquivalent}'),
            actions: [
              IconButton(
                icon: Icon(
                  provider.audioEnabled ? Icons.volume_up : Icons.volume_off,
                ),
                onPressed: provider.toggleAudio,
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                if (provider.showAudioError)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 16,
                      ),
                      color: Colors.red[100],
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Could not play audio. Check your device settings.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[800],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              // Close button logic would go here if needed
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            color: Colors.red[700],
                          ),
                        ],
                      ),
                    ),
                  ),

                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blue[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 500),
                              tween: Tween<double>(begin: 0.8, end: 1.0),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withAlpha(40),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          currentLetter.letter,
                                          style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          currentLetter.smallLetter,
                                          style: const TextStyle(
                                            fontSize: 36,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentLetter.letter} (Capital)',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${currentLetter.smallLetter} (Small)',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pronunciation: ${currentLetter.pronunciation}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        color: Colors.amber[50],
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.amber),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Trace the letter by following the blue path. Try to stay on the path for better accuracy!',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (currentLetter.unlockedWords.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border(
                              top: BorderSide(
                                color: Colors.green[100]!,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Colors.green[100]!,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.bookmark, color: Colors.green[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Example Word:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      currentLetter.unlockedWords.first,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up),
                                onPressed: () {
                                  provider.playSound(
                                    'assets/audio/words/${currentLetter.unlockedWords.first.toLowerCase()}.mp3',
                                  );
                                },
                                color: Colors.green[700],
                              ),
                            ],
                          ),
                        ),

                      SizedBox(
                        height: 450,
                        child: NotificationListener<ScrollNotification>(
                          // This prevents scroll events from bubbling up to parent scrollables
                          onNotification: (_) => true,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: LetterTracingWidget(
                              letter: currentLetter,
                              onAccuracyChanged: _handleAccuracyChanged,
                              onCompleted: _handleLetterCompleted,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: provider.playLetterSound,
                              icon: const Icon(Icons.volume_up),
                              label: const Text('Listen to pronunciation'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 3,
                              ),
                            ),

                            const SizedBox(width: 12),

                            if (currentLetter.practiceCount > 0)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.repeat,
                                      color: Colors.blue[700],
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Practiced ${currentLetter.practiceCount} ${currentLetter.practiceCount == 1 ? 'time' : 'times'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),

                      if (currentLetter.exampleSentence.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.purple[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.format_quote,
                                    color: Colors.purple[700],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Example Sentence:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple[800],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentLetter.exampleSentence,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: Colors.purple[900],
                                ),
                              ),
                              if (currentLetter.meaningOfSentence.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Meaning: ${currentLetter.meaningOfSentence}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                if (_showCelebration)
                  CelebrationOverlay(
                    controller: _celebrationController,
                    onDone: _handleCelebrationDone,
                    treasureWord: treasureWord,
                    letterCompleted: currentLetter.letter,
                    latinEquivalent: currentLetter.latinEquivalent,
                    accuracy: _accuracy,
                    exampleSentence: currentLetter.exampleSentence,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
