import '../entities/land.dart';
import '../repositories/qubee_quest_repository.dart';

class GetLands {
  final QubeeQuestRepository repository;

  GetLands(this.repository);

  Future<List<Land>> call() async {
    return repository.getLands();
  }
}