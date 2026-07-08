import '../entities/shed_stock.dart';
import '../repositories/estokar_shed_repository.dart';

class UpdateShed {
  final EstokarShedRepository repository;

  UpdateShed(this.repository);

  Future<void> call(ShedStock shed) async {
    return repository.updateShed(shed);
  }
}

