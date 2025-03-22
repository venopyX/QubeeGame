import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../features/hibboo/data/datasources/hibboo_datasource.dart';
import '../../features/hibboo/data/repositories/hibboo_repository_impl.dart';
import '../../features/hibboo/domain/usecases/get_hibboo_list.dart';
import '../../features/hibboo/presentation/providers/hibboo_provider.dart';
import '../../features/qubee_quest/presentation/providers/qubee_quest_provider.dart';
import '../../features/playhouse/data/datasources/playhouse_datasource.dart';
import '../../features/playhouse/data/repositories/playhouse_repository_impl.dart';
import '../../features/playhouse/domain/usecases/get_videos.dart';
import '../../features/playhouse/domain/usecases/track_video_progress.dart';
import '../../features/playhouse/presentation/providers/playhouse_provider.dart';
import '../../features/word_matching/data/datasources/word_matching_datasource.dart';
import '../../features/word_matching/data/repositories/word_matching_repository_impl.dart';
import '../../features/word_matching/domain/usecases/get_word_pairs.dart';
import '../../features/word_matching/presentation/providers/word_matching_provider.dart';

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

  // Add Word Matching Provider
  ChangeNotifierProvider(
    create: (_) {
      final datasource = WordMatchingDatasource();
      final repository = WordMatchingRepositoryImpl(datasource);
      final getWordPairs = GetWordPairs(repository);
      return WordMatchingProvider(getWordPairs);
    },
  ),
  // Add other providers here later (e.g., AuthProvider, GameProvider)
];