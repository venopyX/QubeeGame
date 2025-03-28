import '../entities/hibboo.dart';
import '../repositories/hibboo_repository.dart';

/// Use case for retrieving the list of Hibboo riddles
class GetHibbooList {
  /// The repository used to fetch Hibboo data
  final HibbooRepository repository;

  /// Creates a new GetHibbooList use case
  const GetHibbooList(this.repository);

  /// Executes the use case to retrieve Hibboo riddles
  ///
  /// Returns a Future that completes with a list of [Hibboo] objects
  Future<List<Hibboo>> call() async {
    return await repository.getHibbooList();
  }
}
