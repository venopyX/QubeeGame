import '../entities/qubee.dart';
import '../repositories/qubee_quest_repository.dart';

class GetQubeeLetters {
  final QubeeQuestRepository repository;

  GetQubeeLetters(this.repository);

  Future<List<Qubee>> call() async {
    return repository.getQubeeLetters();
  }
}