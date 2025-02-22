// lib/app/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/hibboo/presentation/pages/hibboo_dashboard_page.dart';
import '../../features/hibboo/presentation/pages/hibboo_playing_page.dart';

class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String hibbooDashboard = '/hibboo_dashboard';
  static const String hibbooPlaying = '/hibboo_playing';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case hibbooDashboard:
        return MaterialPageRoute(builder: (_) => const HibbooDashboardPage());
      case hibbooPlaying:
        return MaterialPageRoute(builder: (_) => const HibbooPlayingPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}