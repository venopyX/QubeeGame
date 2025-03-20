import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/hibboo_provider.dart';

class HibbooPlayingPage extends StatefulWidget {
  const HibbooPlayingPage({super.key});

  @override
  _HibbooPlayingPageState createState() => _HibbooPlayingPageState();
}

class _HibbooPlayingPageState extends State<HibbooPlayingPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _confettiController;
  String? _hint;
  List<String> _scrambledLetters = [];
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _checkAnswer(HibbooProvider provider) {
    final String correctAnswer = provider.currentHibboo.answer.toLowerCase();
    final String userAnswer = _controller.text.toLowerCase();

    // Calculate similarity between user's answer and correct answer
    bool isCorrect = false;
    bool isCloseEnough = false;

    if (userAnswer == correctAnswer) {
      isCorrect = true;
    } else {
      // Check if the answer is "close enough" (similar spelling)
      isCloseEnough = _isAnswerCloseEnough(userAnswer, correctAnswer);
    }

    if (isCorrect || isCloseEnough) {
      setState(() => _showConfetti = true);
      _confettiController.forward(from: 0).then((_) {
        setState(() => _showConfetti = false);
      });

      // Get current hibboo and advance to next one
      final solvedHibboo = provider.solveAndAdvance();

      _showSuccessDialog(
        provider.hasAchievement,
        solvedHibboo.text,
        solvedHibboo.answer,
        userAnswer,
        isExactMatch: isCorrect,
      );

      _controller.clear();
      setState(() {
        _hint = null;
        _scrambledLetters = [];
      });
    } else {
      _showErrorEffect();
    }
  }

  // Helper function to check if the user's answer is close enough
  bool _isAnswerCloseEnough(String userAnswer, String correctAnswer) {
    // If length difference is too great, it's not close enough
    if ((userAnswer.length - correctAnswer.length).abs() > 2) {
      return false;
    }

    // Calculate edit distance (Levenshtein distance)
    int distance = _calculateLevenshteinDistance(userAnswer, correctAnswer);

    // Allow for small differences based on word length
    int maxAllowedDistance = (correctAnswer.length / 4).ceil();

    // For very short words, always allow at least 1 character difference
    maxAllowedDistance = maxAllowedDistance < 1 ? 1 : maxAllowedDistance;

    return distance <= maxAllowedDistance;
  }

  // Levenshtein distance calculation to determine string similarity
  int _calculateLevenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    List<int> prevRow = List<int>.generate(s2.length + 1, (i) => i);
    List<int> currentRow = List<int>.filled(s2.length + 1, 0);

    for (int i = 0; i < s1.length; i++) {
      currentRow[0] = i + 1;

      for (int j = 0; j < s2.length; j++) {
        int insertCost = prevRow[j + 1] + 1;
        int deleteCost = currentRow[j] + 1;
        int replaceCost = prevRow[j] + (s1[i] != s2[j] ? 1 : 0);

        currentRow[j + 1] = [
          insertCost,
          deleteCost,
          replaceCost,
        ].reduce((curr, next) => curr < next ? curr : next);
      }

      // Swap current and previous rows
      final temp = prevRow;
      prevRow = currentRow;
      currentRow = temp;
    }

    return prevRow[s2.length];
  }

  void _showSuccessDialog(
    bool isAchievement,
    String questionText,
    String correctAnswer,
    String userAnswer, {
    bool isExactMatch = true,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isAchievement ? Icons.emoji_events : Icons.celebration,
                  color: isAchievement ? Colors.amber[700] : Colors.amber,
                  size: isAchievement ? 60 : 50,
                ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                const SizedBox(height: 16),
                Text(
                  isAchievement ? 'Achievement Unlocked!' : 'Excellent!',
                  style: TextStyle(
                    fontSize: isAchievement ? 26 : 24,
                    fontWeight: FontWeight.bold,
                    color: isAchievement ? Colors.amber[700] : Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAchievement
                      ? '85+ Correct Answers!'
                      : 'You\'ve solved the Hibboo!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight:
                        isAchievement ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                // Display the question and answer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Question:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        questionText,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Answer:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        userAnswer,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              isExactMatch
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (!isExactMatch) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Correct Spelling:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          correctAnswer,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isAchievement) ...[
                  const SizedBox(height: 16),
                  _buildAchievementConfetti(),
                ],
              ],
            ),
          ),
    );
  }

  Widget _buildAchievementConfetti() {
    return SizedBox(
      height: 100,
      child: Stack(
        children: List.generate(30, (index) {
          final random = math.Random();
          final color =
              [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.purple,
                Colors.orange,
              ][random.nextInt(6)];

          return Positioned(
            left: random.nextDouble() * 280,
            top: random.nextDouble() * 100,
            child: Icon(
                  Icons.star,
                  color: color,
                  size: 10 + random.nextDouble() * 15,
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(delay: (random.nextDouble() * 500).ms, duration: 300.ms)
                .moveY(
                  begin: 20,
                  end: -20,
                  duration: (1000 + random.nextDouble() * 1000).ms,
                  curve: Curves.easeOutQuad,
                ),
          );
        }),
      ),
    );
  }

  void _showErrorEffect() {
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Try again!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HibbooProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Solve Hibboo',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.brown[800],
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildProgressIndicator(provider),
                ],
              );
            },
          ),
        ),
        actions: [
          // Achievement badge indicator
          if (provider.hasAchievement)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.emoji_events,
                color: Colors.amber[700],
              ).animate().custom(
                duration: const Duration(milliseconds: 300),
                delay: const Duration(seconds: 2),
                builder:
                    (context, value, child) => Transform.scale(
                      scale: 1.0 + (value * 0.2),
                      child: child,
                    ),
              ),
            ),
        ],
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      // Main Content
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Level indicator
                            _buildLevelIndicator(provider),
                            const SizedBox(height: 16),

                            // Hibboo Question Card
                            _buildQuestionCard(context, provider),
                            const SizedBox(height: 32),

                            // Answer Input Section
                            _buildAnswerSection(),
                            const SizedBox(height: 24),

                            // Action Buttons
                            _buildActionButtons(provider),
                            const SizedBox(height: 24),

                            // Hint Section
                            if (_hint != null) _buildHintSection(),

                            // Achievement counter
                            _buildAchievementProgress(provider),
                          ],
                        ),
                      ),

                      // Confetti Overlay
                      if (_showConfetti) _buildConfettiOverlay(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildLevelIndicator(HibbooProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: Colors.amber[700], size: 16),
          const SizedBox(width: 4),
          Text(
            'Level ${provider.currentLevel}',
            style: TextStyle(
              color: Colors.amber[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementProgress(HibbooProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievement Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Progress bar background
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Progress indicator
              FractionallySizedBox(
                widthFactor: math.min(provider.correctAnswers / 85, 1.0),
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors:
                          provider.hasAchievement
                              ? [Colors.amber[400]!, Colors.amber[700]!]
                              : [Colors.green[300]!, Colors.green[600]!],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${provider.correctAnswers} / 85 answers',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              if (provider.hasAchievement)
                Text(
                  'Achievement Unlocked!',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, HibbooProvider provider) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.question_mark, size: 40, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              provider.currentHibboo.text,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.brown[800],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
  }

  Widget _buildAnswerSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type your answer here...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          icon: Icon(Icons.lightbulb_outline, color: Colors.amber[700]),
        ),
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildActionButtons(HibbooProvider provider) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _checkAnswer(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline),
                SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _hint = provider.currentHibboo.answer;
              _scrambledLetters = _hint!.split('')..shuffle();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
          ),
          child: const Icon(Icons.lightbulb),
        ),
      ],
    );
  }

  Widget _buildHintSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hint',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _scrambledLetters
                    .map((letter) => _buildLetterTile(letter))
                    .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildLetterTile(String letter) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(HibbooProvider provider) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_florist, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            '${provider.growthPoints}/100',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    return CustomPaint(
      painter: ConfettiPainter(controller: _confettiController),
      child: Container(),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final AnimationController controller;

  ConfettiPainter({required this.controller}) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.fill;

    final random = math.Random();

    for (var i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 4, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
