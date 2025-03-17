import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/setup.dart';
import 'routes/app_routes.dart';
import '../../features/home/presentation/pages/home_page.dart';

class QubeeGameApp extends StatelessWidget {
  const QubeeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QubeeGames',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(), // Set home page
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}