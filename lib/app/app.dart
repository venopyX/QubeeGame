import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/setup.dart';
import 'routes/app_routes.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../shared/themes/app_theme.dart';

/// The main application widget for QubeeGames.
///
/// This widget is the root of the application and sets up the theme,
/// providers, and initial routes.
class QubeeGameApp extends StatelessWidget {
  const QubeeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QubeeGames',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        home: const HomePage(),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}