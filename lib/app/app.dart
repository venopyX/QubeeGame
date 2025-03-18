import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/setup.dart';
import 'routes/app_routes.dart';
import '../../features/home/presentation/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class QubeeGameApp extends StatelessWidget {
  const QubeeGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'QubeeGame',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.nunitoTextTheme(),
          useMaterial3: true,
          cardTheme: const CardTheme(
            clipBehavior: Clip.antiAlias,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.nunitoTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(), // Set home page
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}