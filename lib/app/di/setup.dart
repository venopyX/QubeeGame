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

/// Initializes application-wide dependencies
void setupDependencies() {
  // Add more initialization logic here as your app grows
}

/// A list of providers for the MultiProvider widget
///
/// This provides application-wide state management through Provider pattern
List<SingleChildWidget> get providers => [
  ChangeNotifierProvider(
    create: (_) {
      final datasource = HibbooDatasource();
      final repository = HibbooRepositoryImpl(datasource);
      final getHibbooList = GetHibbooList(repository);
      return HibbooProvider(getHibbooList);
    },
  ),

  ChangeNotifierProvider(create: (_) => QubeeQuestProvider()),

  ChangeNotifierProvider(
    create: (_) {
      final datasource = PlayhouseDatasource();
      final repository = PlayhouseRepositoryImpl(datasource);
      final getVideos = GetVideos(repository);
      final trackVideoProgress = TrackVideoProgress(repository);
      return PlayhouseProvider(getVideos, trackVideoProgress);
    },
  ),

  ChangeNotifierProvider(
    create: (_) {
      final datasource = WordMatchingDatasource();
      final repository = WordMatchingRepositoryImpl(datasource);
      final getWordPairs = GetWordPairs(repository);
      return WordMatchingProvider(getWordPairs);
    },
  ),
];
