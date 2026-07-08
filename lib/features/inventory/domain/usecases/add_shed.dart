import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_shed_repository.dart';

import '../entities/shed_stock.dart';
import '../services/id_generator.dart';

class AddShed {
  final EstokarShedRepository repository;
  final IdGenerator idGenerator;

  AddShed(this.repository, this.idGenerator);

  Future<void> call({
    required String nome,
    required String locate,
    required int maxCapacity,
  }) async {
    final shed = ShedStock(
      id: idGenerator.generate(),
      nome: nome,
      locate: locate,
      maxCapacity: maxCapacity,
    );
    return repository.addShed(shed);
  }
}

