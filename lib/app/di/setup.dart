import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/hibboo/data/datasources/hibboo_datasource.dart';
import '../../features/hibboo/data/repositories/hibboo_repository_impl.dart';
import '../../features/hibboo/domain/usecases/get_hibboo_list.dart';
import '../../features/hibboo/presentation/providers/hibboo_provider.dart';
import '../../features/qubee_quest/presentation/providers/qubee_quest_provider.dart';

// Singleton instances for Providers
void setupDependencies() {
  // Add more providers here as your app grows
}

// Root widget with MultiProvider
List<SingleChildWidget> get providers => [
  ChangeNotifierProvider(
    create: (_) {
      final datasource = HibbooDatasource();
      final repository = HibbooRepositoryImpl(datasource);
      final getHibbooList = GetHibbooList(repository);
      return HibbooProvider(getHibbooList);
    },
  ),
  // Updated QubeeQuestProvider that doesn't require use cases
  ChangeNotifierProvider(
    create: (_) => QubeeQuestProvider(),
  ),
];