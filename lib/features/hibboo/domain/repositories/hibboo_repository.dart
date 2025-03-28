import '../entities/hibboo.dart';

/// Repository interface for Hibboo data access
abstract class HibbooRepository {
  /// Retrieves a list of Hibboo riddles
  /// 
  /// Returns a Future that completes with a list of [Hibboo] objects
  Future<List<Hibboo>> getHibbooList();
}