import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hibboo_provider.dart';
import '../widgets/tree_widget.dart';
import '../../../../app/routes/app_routes.dart';

class HibbooDashboardPage extends StatelessWidget {
  const HibbooDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HibbooProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hibboo Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TreeWidget(stage: provider.currentStage),
            const SizedBox(height: 20),
            Text('Stage: ${provider.currentStage}'),
            Text('Growth Points: ${provider.growthPoints}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.hibbooPlaying);
              },
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}