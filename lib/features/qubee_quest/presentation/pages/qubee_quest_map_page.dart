import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/qubee_quest_provider.dart';
import '../widgets/land_card_widget.dart';
import '../widgets/treasure_collection_widget.dart';

class QubeeQuestMapPage extends StatelessWidget {
  const QubeeQuestMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<QubeeQuestProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              _buildHeader(context, provider),
              _buildLandsList(context, provider),
              _buildTreasureSection(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[700]!,
                Colors.blue[500]!,
              ],
            ),
          ),
        ),
        title: Text(
          'Qubee Quest',
          style: TextStyle(
            color: Colors.white.withOpacity(0.95),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Consumer<QubeeQuestProvider>(
          builder: (context, provider, _) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${provider.points} points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, QubeeQuestProvider provider) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adventures Map',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore magical lands and learn Qubee letters',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandsList(BuildContext context, QubeeQuestProvider provider) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final land = provider.lands[index];
          
          // Count completed letters in the land
          final letterIds = land.letterIds;
          final completedCount = provider.letters
              .where((letter) => letterIds.contains(letter.id) && letter.isCompleted)
              .length;
              
          return LandCardWidget(
            land: land,
            completedLetters: completedCount,
            totalLetters: letterIds.length,
            onTap: () {
              if (land.isUnlocked) {
                provider.selectLand(land);
                Navigator.pushNamed(context, '/qubee_quest_land');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You need ${land.requiredPoints} points to unlock ${land.name}'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
        },
        childCount: provider.lands.length,
      ),
    );
  }

  Widget _buildTreasureSection(BuildContext context, QubeeQuestProvider provider) {
    final collectedTreasures = provider.collectedTreasures;
    if (collectedTreasures.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Treasures',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Words you have discovered so far',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            TreasureCollectionWidget(treasures: collectedTreasures),
          ],
        ),
      ),
    );
  }
}