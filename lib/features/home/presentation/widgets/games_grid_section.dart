import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/widgets/game_card.dart';
import '../../domain/entities/game_info.dart';
import '../../../../app/routes/app_routes.dart';

/// A grid section displaying available games
class GamesGridSection extends StatelessWidget {
  const GamesGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      GameInfo(
        title: 'Oromo Playhouse',
        description: 'Learn with fun videos and mini-games',
        icon: Icons.video_library,
        color: Colors.orange,
        comingSoon: false,
        routeName: AppRoutes.playhouseDashboard,
      ),
      GameInfo(
        title: 'Word Weaver',
        description: 'Create words from Qubee letters',
        icon: Icons.abc,
        color: Colors.purple,
        comingSoon: true,
      ),
      GameInfo(
        title: 'Story Tap',
        description: 'Interactive Oromo stories',
        icon: Icons.auto_stories,
        color: Colors.blue,
        comingSoon: true,
      ),
      GameInfo(
        title: 'Culture Quest',
        description: 'Explore Oromo traditions',
        icon: Icons.psychology,
        color: Colors.teal,
        comingSoon: true,
      ),
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => GameCard(
            title: games[index].title,
            description: games[index].description,
            icon: games[index].icon,
            color: games[index].color,
            comingSoon: games[index].comingSoon,
            onTap:
                games[index].comingSoon
                    ? null
                    : () {
                      if (games[index].routeName != null) {
                        Navigator.pushNamed(context, games[index].routeName!);
                      }
                    },
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2),
          childCount: games.length,
        ),
      ),
    );
  }
}
