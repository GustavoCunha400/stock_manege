import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_shed_repository.dart';

class RemoveShed {
  final EstokarShedRepository repository;

  RemoveShed(this.repository);

  Future<void> call(String id) async => repository.deleteShed(id);
}

