import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/letter_tracing_widget.dart';
import '../widgets/celebration_overlay.dart';

class QubeeQuestLetterPage extends StatefulWidget {
  final int letterId;
  
  const QubeeQuestLetterPage({
    required this.letterId,
    Key? key,
  }) : super(key: key);

  @override
  State<QubeeQuestLetterPage> createState() => _QubeeQuestLetterPageState();
}

class _QubeeQuestLetterPageState extends State<QubeeQuestLetterPage> with SingleTickerProviderStateMixin {
  bool _showCelebration = false;
  double _accuracy = 0.0;
  late AnimationController _celebrationController;
  
  @override
  void initState() {
    super.initState();
    // Select the current letter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QubeeQuestProvider>(context, listen: false);
      provider.selectLetter(widget.letterId);
      
      // Play letter sound
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

  void _handleLetterCompleted() {
    final provider = Provider.of<QubeeQuestProvider>(context, listen: false);
    provider.completeCurrentLetter(_accuracy);
    
    // Play success sound
    provider.playSound('assets/audio/success.mp3');
    
    setState(() {
      _showCelebration = true;
    });
  }
  
  void _handleAccuracyChanged(double accuracy) {
    _accuracy = accuracy;
  }
  
  void _handleCelebrationDone() {
    if (mounted) {
      Navigator.of(context).pop(); // Return to the map
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
        
        // Get treasure for this letter
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
          // Use a SafeArea wrapped SingleChildScrollView for scrollable content
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Letter information header
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.blue[50],
                        child: Row(
                          children: [
                            // Letter display - now with uppercase and lowercase
                            Container(
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentLetter.letter, // Uppercase
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    currentLetter.smallLetter, // Lowercase
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            
                            // Letter information
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

                      // Instructions
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                      
                      // Example word
                      if (currentLetter.unlockedWords.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Colors.green[50],
                          child: Row(
                            children: [
                              Icon(Icons.bookmark, color: Colors.green[700]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Example word: ${currentLetter.unlockedWords.first}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Main letter tracing widget - explicitly sized with a fixed height
                      SizedBox(
                        height: 450, // Give it plenty of explicit height
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: LetterTracingWidget(
                            letter: currentLetter,
                            onAccuracyChanged: _handleAccuracyChanged,
                            onCompleted: _handleLetterCompleted,
                          ),
                        ),
                      ),
                      
                      // Listen to pronunciation button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Celebration overlay when letter is completed
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