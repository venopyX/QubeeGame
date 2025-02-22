import '../../domain/entities/hibboo.dart';
import '../../domain/repositories/hibboo_repository.dart';
import '../datasources/hibboo_datasource.dart';
import '../models/hibboo_model.dart';

class HibbooRepositoryImpl implements HibbooRepository {
  final HibbooDatasource datasource;

  HibbooRepositoryImpl(this.datasource);

  @override
  Future<List<Hibboo>> getHibbooList() async {
    final List<HibbooModel> models = await datasource.getHibbooList();
    return models.map((model) => Hibboo(
      text: model.text,
      answer: model.answer,
      stage: model.stage,
    )).toList();
  }
}