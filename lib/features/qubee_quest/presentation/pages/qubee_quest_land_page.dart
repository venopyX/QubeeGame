import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/qubee.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/qubee_letter_card_widget.dart';

class QubeeQuestLandPage extends StatelessWidget {
  const QubeeQuestLandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QubeeQuestProvider>(
        builder: (context, provider, _) {
          if (provider.currentLand == null) {
            return const Center(child: Text('No land selected'));
          }

          final land = provider.currentLand!;
          final landLetters =
              provider.letters
                  .where((letter) => land.letterIds.contains(letter.id))
                  .toList();

          return CustomScrollView(
            slivers: [
              _buildAppBar(context, land),
              _buildHeader(context, land),
              _buildLetterGrid(context, provider, landLetters),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, land) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Land image
            Image.asset(
              land.imagePath,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue[700]!, Colors.blue[900]!],
                      ),
                    ),
                    child: const Icon(
                      Icons.landscape,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
            ),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          land.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: false,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, land) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              land.description,
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Qubee Letters',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap on a letter to start tracing',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterGrid(
    BuildContext context,
    QubeeQuestProvider provider,
    List<Qubee> landLetters,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final letter = landLetters[index];
          return QubeeLetterCardWidget(
                letter: letter,
                onTap: () {
                  if (letter.isUnlocked) {
                    provider.selectLetter(letter);
                    Navigator.pushNamed(context, '/qubee_quest_letter');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You need ${letter.requiredPoints} points to unlock ${letter.letter}',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
              )
              .animate()
              .fadeIn(delay: (100 * index).ms)
              .scale(begin: const Offset(0.8, 0.8));
        }, childCount: landLetters.length),
      ),
    );
  }
}
