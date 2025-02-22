import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QubeeGame'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.dashboard);
            },
          ),
          ListTile(
            title: const Text('Hibboo'),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.hibbooDashboard);
            },
          ),
          // Add more games here
        ],
      ),
    );
  }
}