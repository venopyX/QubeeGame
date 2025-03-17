import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/hibboo/data/datasources/hibboo_datasource.dart';
import '../../features/hibboo/data/repositories/hibboo_repository_impl.dart';
import '../../features/hibboo/domain/usecases/get_hibboo_list.dart';
import '../../features/hibboo/presentation/providers/hibboo_provider.dart';
import '../../features/playhouse/data/datasources/playhouse_datasource.dart';
import '../../features/playhouse/data/repositories/playhouse_repository_impl.dart';
import '../../features/playhouse/domain/usecases/get_videos.dart';
import '../../features/playhouse/domain/usecases/track_video_progress.dart';
import '../../features/playhouse/presentation/providers/playhouse_provider.dart';

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

  // Add Playhouse Provider (updated for new implementation)
  ChangeNotifierProvider(
    create: (_) {
      final datasource = PlayhouseDatasource();
      final repository = PlayhouseRepositoryImpl(datasource);
      final getVideos = GetVideos(repository);
      final trackVideoProgress = TrackVideoProgress(repository);
      return PlayhouseProvider(getVideos, trackVideoProgress);
    },
  ),
  // Add other providers here later (e.g., AuthProvider, GameProvider)
];