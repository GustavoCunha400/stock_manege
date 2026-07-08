import '../entities/shed_stock.dart';
import '../repositories/estokar_shed_repository.dart';

class EditShed {
  final EstokarShedRepository repository;

  EditShed(this.repository);

  Future<bool> call({
    required ShedStock shed,
    required String nome,
    required String locate,
    required int maxCapacity,
  }) async {
    final cleanName = nome.trim();
    final cleanLocate = locate.trim();

    if (cleanName.isEmpty || cleanLocate.isEmpty || maxCapacity <= 0) {
      return false;
    }

    await repository.updateShed(
      shed.copyWith(
        nome: cleanName,
        locate: cleanLocate,
        maxCapacity: maxCapacity,
      ),
    );
    return true;
  }
}

