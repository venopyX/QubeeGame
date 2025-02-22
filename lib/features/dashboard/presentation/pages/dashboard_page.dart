import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QubeeGame Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<DashboardProvider>(
              builder: (context, provider, child) {
                return provider.isLoading
                    ? const CircularProgressIndicator()
                    : DashboardCard(
                        title: 'Welcome!',
                        content: 'Counter: ${provider.counter}',
                      );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<DashboardProvider>(context, listen: false)
                    .incrementCounter();
              },
              child: const Text('Increment'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<DashboardProvider>(context, listen: false)
                    .toggleLoading();
              },
              child: const Text('Toggle Loading'),
            ),
          ],
        ),
      ),
    );
  }
}