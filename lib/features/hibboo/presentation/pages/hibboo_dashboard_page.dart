import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hibboo_provider.dart';
import '../widgets/lottie_tree_widget.dart'; // Updated import
import '../../../../app/routes/app_routes.dart';

class HibbooDashboardPage extends StatelessWidget {
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
          // Achievement badge indicator
          if (provider.hasAchievement)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.emoji_events,
                color: Colors.amber[700],
              ),
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
                    // Using the new Lottie tree widget instead of the old TreeWidget
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
                          
                          // Achievement counter
                          if (provider.correctAnswers > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _buildAchievementProgress(provider),
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Level ${provider.currentLevel}',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: provider.growthPoints / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[300]!),
            borderRadius: BorderRadius.circular(10),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
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
  
  Widget _buildAchievementProgress(HibbooProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: provider.hasAchievement ? Colors.amber : Colors.grey.withOpacity(0.3),
          width: provider.hasAchievement ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                provider.hasAchievement ? Icons.emoji_events : Icons.article,
                color: provider.hasAchievement ? Colors.amber[700] : Colors.grey[600],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                provider.hasAchievement ? 'Achievement Unlocked!' : 'Word Mastery',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: provider.hasAchievement ? Colors.amber[700] : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Progress bar background
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Progress indicator
              FractionallySizedBox(
                widthFactor: provider.correctAnswers / 85 > 1 ? 1 : provider.correctAnswers / 85,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: provider.hasAchievement
                          ? [Colors.amber[400]!, Colors.amber[700]!]
                          : [Colors.green[300]!, Colors.green[500]!],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${provider.correctAnswers} / 85 correct answers',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}