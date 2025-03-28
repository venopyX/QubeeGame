import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hibboo_provider.dart';
import '../widgets/lottie_tree_widget.dart';
import '../widgets/achievement_progress_card.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../shared/widgets/rounded_badge.dart';
import '../../../../shared/widgets/gradient_progress_indicator.dart';

/// Dashboard page for the Hibboo game feature
class HibbooDashboardPage extends StatelessWidget {
  /// Creates a HibbooDashboardPage
  const HibbooDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HibbooProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Hibboo Garden',
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
          if (provider.hasAchievement)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(Icons.emoji_events, color: Colors.amber[700]),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[100]!, Colors.blue[50]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    LottieTreeWidget(
                      stage: provider.currentStage,
                      growthPoints: provider.growthPoints,
                      showSparkles: provider.growthPoints > 0,
                    ),
                    Positioned(
                      bottom: 32,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          _buildStageCard(context, provider),
                          const SizedBox(height: 16),
                          _buildPlayButton(context),

                          if (provider.correctAnswers > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: AchievementProgressCard(
                                correctAnswers: provider.correctAnswers,
                                targetAnswers: 85,
                                achievementUnlocked: provider.hasAchievement,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildStageCard(BuildContext context, HibbooProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                provider.currentStage,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.brown[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              RoundedBadge(
                text: 'Level ${provider.currentLevel}',
                backgroundColor: Colors.amber.withValues(alpha: 0.2),
                textColor: Colors.amber[700]!,
              ),
            ],
          ),
          const SizedBox(height: 8),
          GradientProgressIndicator(
            value: provider.growthPoints / 100,
            backgroundColor: Colors.grey[200]!,
            startColor: Colors.green[300]!,
            endColor: Colors.green[500]!,
            borderRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.hibbooPlaying);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow),
            SizedBox(width: 8),
            Text(
              'Play Hibboo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
