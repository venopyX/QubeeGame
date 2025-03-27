import '../../domain/entities/hibboo.dart';
import '../../domain/repositories/hibboo_repository.dart';
import '../datasources/hibboo_datasource.dart';

/// Implementation of the HibbooRepository
class HibbooRepositoryImpl implements HibbooRepository {
  /// The data source used to retrieve Hibboo data
  final HibbooDatasource datasource;

  /// Creates a new HibbooRepositoryImpl instance
  const HibbooRepositoryImpl(this.datasource);

  @override
  Future<List<Hibboo>> getHibbooList() async {
    final models = await datasource.getHibbooList();
    return models;
  }
}
