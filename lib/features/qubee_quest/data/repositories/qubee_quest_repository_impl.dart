import '../../domain/repositories/qubee_quest_repository.dart';
import '../datasources/qubee_quest_datasource.dart';
import '../../domain/entities/qubee.dart';
import '../../domain/entities/land.dart';
import '../models/qubee_model.dart';
import '../models/land_model.dart';

class QubeeQuestRepositoryImpl implements QubeeQuestRepository {
  final QubeeQuestDatasource _datasource;

  QubeeQuestRepositoryImpl(this._datasource);

  @override
  Future<List<Qubee>> getQubeeLetters() async {
    try {
      return await _datasource.getQubeeLetters();
    } catch (e) {
      // If loading from assets fails, return sample data
      return await _datasource.getSampleQubeeLetters();
    }
  }

  @override
  Future<List<Land>> getLands() async {
    try {
      return await _datasource.getLands();
    } catch (e) {
      // If loading from assets fails, return sample data
      return await _datasource.getSampleLands();
    }
  }
}