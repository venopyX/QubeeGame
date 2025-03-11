// lib/app/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../../features/hibboo/presentation/pages/hibboo_dashboard_page.dart';
import '../../features/hibboo/presentation/pages/hibboo_playing_page.dart';
import '../../features/playhouse/presentation/pages/playhouse_dashboard_page.dart';

class AppRoutes {
  static const String hibbooDashboard = '/hibboo_dashboard';
  static const String hibbooPlaying = '/hibboo_playing';
  static const String playhouseDashboard = '/playhouse_dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case hibbooDashboard:
        return MaterialPageRoute(builder: (_) => const HibbooDashboardPage());
      case hibbooPlaying:
        return MaterialPageRoute(builder: (_) => const HibbooPlayingPage());
      case playhouseDashboard:
        return MaterialPageRoute(builder: (_) => const PlayhouseDashboardPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}