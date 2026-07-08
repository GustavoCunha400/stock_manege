import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_shed_repository.dart';

import '../entities/shed_stock.dart';

class GetShed {
  final EstokarShedRepository repository;

  GetShed(this.repository);

  Future<List<ShedStock>> call() async => repository.getShed();
}
