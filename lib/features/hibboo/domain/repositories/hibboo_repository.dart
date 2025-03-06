import '../entities/hibboo.dart';

abstract class HibbooRepository {
  Future<List<Hibboo>> getHibbooList();
}