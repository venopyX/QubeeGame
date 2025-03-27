import 'package:flutter/material.dart';
import '../../features/hibboo/presentation/pages/hibboo_dashboard_page.dart';
import '../../features/hibboo/presentation/pages/hibboo_playing_page.dart';
import '../../features/qubee_quest/presentation/pages/qubee_quest_map_page.dart';
import '../../features/qubee_quest/presentation/pages/qubee_quest_letter_page.dart';
import '../../features/playhouse/presentation/pages/playhouse_dashboard_page.dart';
import '../../features/playhouse/presentation/pages/playhouse_playing_page.dart';
import '../../features/word_matching/presentation/pages/word_matching_game_page.dart';

/// Manages application routes and navigation
class AppRoutes {
  /// Route for Hibboo game dashboard
  static const String hibbooDashboard = '/hibboo_dashboard';
  
  /// Route for active Hibboo game play
  static const String hibbooPlaying = '/hibboo_playing';
  
  /// Route for Qubee Quest map screen
  static const String qubeeQuestMap = '/qubee_quest_map';
  
  /// Route for specific letter in Qubee Quest
  static const String qubeeQuestLetter = '/qubee_quest_letter';
  
  /// Route for Playhouse dashboard
  static const String playhouseDashboard = '/playhouse_dashboard';
  
  /// Route for active Playhouse video playback
  static const String playhousePlaying = '/playhouse_playing';
  static const String wordMatchingGame = '/word_matching_game';

  /// Generates route based on route settings
  /// 
  /// This method handles routing to appropriate pages based on route name
  /// and passes arguments when needed.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case hibbooDashboard:
        return MaterialPageRoute(builder: (_) => const HibbooDashboardPage());
      case hibbooPlaying:
        return MaterialPageRoute(builder: (_) => const HibbooPlayingPage());
      case qubeeQuestMap:
        return MaterialPageRoute(builder: (_) => const QubeeQuestMapPage());
      case qubeeQuestLetter:
        final args = settings.arguments as Map<String, dynamic>?;
        final int letterId = args?['letterId'] ?? 1;
        return MaterialPageRoute(
          builder: (_) => QubeeQuestLetterPage(letterId: letterId),
        );
      case playhouseDashboard:
        return MaterialPageRoute(builder: (_) => const PlayhouseDashboardPage());
      case playhousePlaying:
        return MaterialPageRoute(builder: (_) => const PlayhousePlayingPage());
      case wordMatchingGame:
        return MaterialPageRoute(builder: (_) => const WordMatchingGamePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}