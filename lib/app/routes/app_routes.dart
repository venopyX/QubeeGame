// lib/app/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../../features/hibboo/presentation/pages/hibboo_dashboard_page.dart';
import '../../features/hibboo/presentation/pages/hibboo_playing_page.dart';
import '../../features/qubee_quest/presentation/pages/qubee_quest_map_page.dart';
import '../../features/qubee_quest/presentation/pages/qubee_quest_letter_page.dart';

class AppRoutes {
  static const String hibbooDashboard = '/hibboo_dashboard';
  static const String hibbooPlaying = '/hibboo_playing';
  static const String qubeeQuestMap = '/qubee_quest_map';
  static const String qubeeQuestLetter = '/qubee_quest_letter';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case hibbooDashboard:
        return MaterialPageRoute(builder: (_) => const HibbooDashboardPage());
      case hibbooPlaying:
        return MaterialPageRoute(builder: (_) => const HibbooPlayingPage());
      case qubeeQuestMap:
        return MaterialPageRoute(builder: (_) => const QubeeQuestMapPage());
      case qubeeQuestLetter:
        // Extract letterId parameter
        final args = settings.arguments as Map<String, dynamic>?;
        final int letterId = args?['letterId'] ?? 1;
        return MaterialPageRoute(
          builder: (_) => QubeeQuestLetterPage(letterId: letterId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}