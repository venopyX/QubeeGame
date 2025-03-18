import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:confetti/confetti.dart';

class CelebrationOverlay extends StatefulWidget {
  final AnimationController controller;
  final VoidCallback onDone;
  final String? treasureWord;
  final double accuracy;
  final String letterCompleted;
  final String latinEquivalent;
  final String? exampleSentence;

  const CelebrationOverlay({
    required this.controller,
    required this.onDone,
    required this.letterCompleted,
    required this.latinEquivalent,
    this.treasureWord,
    this.exampleSentence,
    this.accuracy = 0.0,
    super.key,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  late final ConfettiController _confettiController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();

    _fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
    );

    // Start animation sequence
    widget.controller.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  
  String _getAccuracyMessage() {
    final accuracy = widget.accuracy;
    
    if (accuracy >= 0.95) return 'Perfect!';
    if (accuracy >= 0.90) return 'Excellent!';
    if (accuracy >= 0.80) return 'Great job!';
    if (accuracy >= 0.70) return 'Well done!';
    if (accuracy >= 0.50) return 'Good effort!';
    return 'Keep practicing!';
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Semi-transparent background with blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withAlpha(179),
            ),
          ),

          // Confetti effects
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
              minBlastForce: 10,
              maxBlastForce: 20,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.amber,
              ],
            ),
          ),

          // Main content
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(77),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success animation
                    Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 80,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Success message
                    Text(
                      _getAccuracyMessage(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Letter info - updated to use just the letter
                    Text(
                      'You mastered the letter ${widget.letterCompleted}!',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Accuracy display
                    Text(
                      'Tracing Accuracy: ${(widget.accuracy * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Treasure unlocked (if available)
                    if (widget.treasureWord != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.amber[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withAlpha(77),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: Colors.amber,
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'New Word Unlocked!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber[200]!),
                              ),
                              child: Text(
                                widget.treasureWord!,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[800],
                                ),
                              ),
                            ),
                            
                            // Example sentence
                            if (widget.exampleSentence != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "Example: \"${widget.exampleSentence}\"",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),
                    
                    // Continue button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: widget.onDone,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_forward),
                          SizedBox(width: 8),
                          Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}