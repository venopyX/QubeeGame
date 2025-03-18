import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/qubee_letter_card_widget.dart';
import 'qubee_quest_letter_page.dart';

class QubeeQuestMapPage extends StatefulWidget {
  const QubeeQuestMapPage({Key? key}) : super(key: key);

  @override
  State<QubeeQuestMapPage> createState() => _QubeeQuestMapPageState();
}

class _QubeeQuestMapPageState extends State<QubeeQuestMapPage> {
  @override
  void initState() {
    super.initState();
    // Initialize data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<QubeeQuestProvider>(context, listen: false);
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
              // Points indicator
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                      onTap: letter.isUnlocked 
                          ? () => _navigateToLetterPage(letter.id) 
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}