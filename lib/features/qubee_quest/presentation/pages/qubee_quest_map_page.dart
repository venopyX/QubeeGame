import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/qubee_letter_card_widget.dart';
import 'qubee_quest_letter_page.dart';

class QubeeQuestMapPage extends StatefulWidget {
  const QubeeQuestMapPage({super.key});

  @override
  State<QubeeQuestMapPage> createState() => _QubeeQuestMapPageState();
}

class _QubeeQuestMapPageState extends State<QubeeQuestMapPage> {
  @override
  void initState() {
    super.initState();
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // No need to call any initialization since it happens in the constructor
    });
  }

  void _navigateToLetterPage(int letterId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QubeeQuestLetterPage(letterId: letterId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QubeeQuestProvider>(
      builder: (context, provider, _) {
        final letters = provider.letters;

        if (letters.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Qubee Quest'),
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(
                  provider.audioEnabled ? Icons.volume_up : Icons.volume_off,
                ),
                onPressed: provider.toggleAudio,
              ),
              IconButton(
                icon: const Icon(Icons.emoji_events),
                onPressed: () {
                  // Show treasures collected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Treasures Collected: ${provider.treasures.where((t) => t.isCollected).length}/${provider.treasures.length}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Audio error indicator
              if (provider.showAudioError)
                Container(
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
                    ],
                  ),
                ),

              // Points indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: Colors.amber[100],
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Points: ${provider.points}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Progress: ${provider.letters.where((l) => l.isCompleted).length}/${provider.letters.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                  ],
                ),
              ),

              // Progress path visualization
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.blue[50],
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
                    final letter = letters[index];
                    final isLocked = !letter.isUnlocked;
                    final isCompleted = letter.isCompleted;

                    return Row(
                      children: [
                        // Connection line
                        if (index > 0)
                          Container(
                            width: 20,
                            height: 2,
                            color: isLocked ? Colors.grey[300] : Colors.blue,
                          ),

                        // Letter node
                        GestureDetector(
                          onTap:
                              letter.isUnlocked
                                  ? () => _navigateToLetterPage(letter.id)
                                  : null,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isLocked
                                      ? Colors.grey[200]
                                      : (isCompleted
                                          ? Colors.green
                                          : Colors.blue),
                              border: Border.all(
                                color:
                                    isLocked
                                        ? Colors.grey[400]!
                                        : (isCompleted
                                            ? Colors.green[700]!
                                            : Colors.blue[700]!),
                                width: 2,
                              ),
                              boxShadow: [
                                if (!isLocked)
                                  BoxShadow(
                                    color:
                                        isCompleted
                                            ? Colors.green.withValues(
                                              alpha: 0.3,
                                            )
                                            : Colors.blue.withValues(
                                              alpha: 0.3,
                                            ),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              letter.letter,
                              style: TextStyle(
                                color:
                                    isLocked ? Colors.grey[600] : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Letters grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: letters.length,
                  itemBuilder: (context, index) {
                    final letter = letters[index];

                    return QubeeLetterCardWidget(
                      letter: letter,
                      onTap:
                          letter.isUnlocked
                              ? () => _navigateToLetterPage(letter.id)
                              : null,
                    );
                  },
                ),
              ),
            ],
          ),
          // Add floating action button to show stats
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showStatsDialog(context, provider);
            },
            backgroundColor: Colors.purple,
            child: const Icon(Icons.bar_chart),
          ),
        );
      },
    );
  }

  void _showStatsDialog(BuildContext context, QubeeQuestProvider provider) {
    final completedCount = provider.letters.where((l) => l.isCompleted).length;
    final unlockedCount = provider.unlockedLetterCount;
    final totalCount = provider.letters.length;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Learning Stats'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                const Text('Overall Progress'),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: provider.overallProgress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(provider.overallProgress * 100).toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // Stats grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      context,
                      'Completed',
                      '$completedCount/$totalCount',
                      Colors.green,
                      Icons.check_circle,
                    ),
                    _buildStatItem(
                      context,
                      'Unlocked',
                      '$unlockedCount/$totalCount',
                      Colors.blue,
                      Icons.lock_open,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      context,
                      'Points',
                      '${provider.points}',
                      Colors.amber,
                      Icons.star,
                    ),
                    _buildStatItem(
                      context,
                      'Treasures',
                      '${provider.treasures.where((t) => t.isCollected).length}/${provider.treasures.length}',
                      Colors.purple,
                      Icons.card_giftcard,
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 12)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
