import '../entities/qubee.dart';
import '../entities/land.dart';

abstract class QubeeQuestRepository {
  Future<List<Qubee>> getQubeeLetters();
  Future<List<Land>> getLands();
}