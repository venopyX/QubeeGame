import '../entities/hibboo.dart';
import '../repositories/hibboo_repository.dart';

class GetHibbooList {
  final HibbooRepository repository;

  GetHibbooList(this.repository);

  Future<List<Hibboo>> call() async {
    return await repository.getHibbooList();
  }
}