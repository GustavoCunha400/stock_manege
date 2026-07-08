import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/shed_stock.dart';

abstract class EstokarShedRepository {
  Future<List<ShedStock>> getShed();

  Future<void> addShed(ShedStock shed);

  Future<void> updateShed(ShedStock shed);

  Future<void> deleteShed(String id);
}

