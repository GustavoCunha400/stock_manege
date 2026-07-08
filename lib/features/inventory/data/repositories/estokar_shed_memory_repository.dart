import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/shed_stock.dart';
import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_shed_repository.dart';

class EstokarShedMemoryRepository implements EstokarShedRepository {
  final List<ShedStock> _sheds = [];

  @override
  Future<List<ShedStock>> getShed() async => List.from(_sheds);

  @override
  Future<void> addShed(ShedStock shed) async => _sheds.add(shed);

  @override
  Future<void> updateShed(ShedStock shed) async {
    final index = _sheds.indexWhere((item) => item.id == shed.id);
    if (index == -1) return;

    _sheds[index] = shed;
  }

  @override
  Future<void> deleteShed(String id) async =>
      _sheds.removeWhere((shed) => shed.id == id);
}

