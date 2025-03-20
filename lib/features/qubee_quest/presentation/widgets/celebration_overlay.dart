import 'dart:math';

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
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
    _confettiController.play();

    _fadeAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _scaleAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
    );

    _rotateAnimation = CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(0.1, 0.5, curve: Curves.easeInOut),
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

  Color _getAccuracyColor() {
    final accuracy = widget.accuracy;

    if (accuracy >= 0.90) return Colors.green[900]!;
    if (accuracy >= 0.80) return Colors.green[700]!;
    if (accuracy >= 0.70) return Colors.lightGreen;
    if (accuracy >= 0.50) return Colors.amber;
    return Colors.orange;
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
            child: Container(color: Colors.black.withAlpha(179)),
          ),

          // Multiple confetti effects from different angles
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
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

          // Additional confetti from corners
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 4, // 45 degrees
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 10,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [Colors.red, Colors.purple, Colors.pink],
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3 * pi / 4, // 135 degrees
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 10,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [Colors.blue, Colors.cyan, Colors.teal],
            ),
          ),

          // Main content
          Center(
            child: RotationTransition(
              turns: Tween(begin: -0.02, end: 0.0).animate(_rotateAnimation),
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
                      // Success animation - improved with scaling
                      AnimatedBuilder(
                        animation: widget.controller,
                        builder: (context, child) {
                          return Transform.scale(
                            scale:
                                1.0 +
                                (0.1 * sin(widget.controller.value * 6 * pi)),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getAccuracyColor(),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getAccuracyColor().withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Success message
                      Text(
                        _getAccuracyMessage(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: _getAccuracyColor(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Letter info
                      Text(
                        'You mastered the letter ${widget.letterCompleted}!',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Accuracy display with improved visualization
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.insights,
                              color: Colors.blue[700],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Tracing Accuracy: ${(widget.accuracy * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
                                  Icon(
                                    Icons.emoji_events,
                                    color: Colors.amber[800],
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: [
                                          Colors.amber[800]!,
                                          Colors.orange,
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: Text(
                                      'New Word Unlocked!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              AnimatedBuilder(
                                animation: widget.controller,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale:
                                        1.0 +
                                        (0.05 *
                                            sin(
                                              widget.controller.value * 4 * pi,
                                            )),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.amber[200]!,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.amber.withAlpha(100),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
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
                                  );
                                },
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
          ),
        ],
      ),
    );
  }
}
