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
        title: 'QubeeGame',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(), // Set home page
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}