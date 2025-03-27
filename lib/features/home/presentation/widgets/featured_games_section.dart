import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../shared/widgets/app_gradient_card.dart';

/// A horizontal scrollable section displaying featured games
class FeaturedGamesSection extends StatelessWidget {
  const FeaturedGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(
            'Featured Games',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            children: [
              _buildFeaturedGame(
                context,
                title: 'Hibboo',
                description:
                    'Solve traditional Oromo riddles and grow your wisdom tree',
                color1: Colors.green[400]!,
                color2: Colors.green[600]!,
                iconData: Icons.nature,
                route: AppRoutes.hibbooDashboard,
              ),
              _buildFeaturedGame(
                context,
                title: 'Qubee Quest',
                description:
                    'Learn the Oromo alphabet with exciting adventures',
                color1: Colors.purple[400]!,
                color2: Colors.purple[700]!,
                iconData: Icons.auto_stories,
                route: AppRoutes.qubeeQuestMap,
                isNew: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedGame(
    BuildContext context, {
    required String title,
    required String description,
    required Color color1,
    required Color color2,
    required IconData iconData,
    required String route,
    bool isNew = false,
  }) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: AppGradientCard(
        title: title,
        description: description,
        color1: color1,
        color2: color2,
        iconData: iconData,
        onTap: () => Navigator.pushNamed(context, route),
        isFeatured: true,
        isNew: isNew,
      ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2),
    );
  }
}
