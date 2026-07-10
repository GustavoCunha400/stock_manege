import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/shed_stock.dart';

import '../../domain/usecases/add_shed.dart';
import '../../domain/usecases/edit_shed.dart';
import '../../domain/usecases/get_shed.dart';
import '../../domain/usecases/remove_shed.dart';
import 'collection_controller.dart';

class ShedController extends CollectionController<ShedStock> {
  final GetShed getShed;
  final AddShed addShed;
  final RemoveShed removeShed;
  final EditShed editShedUseCase;

  ShedController({
    required this.getShed,
    required this.addShed,
    required this.removeShed,
    required this.editShedUseCase,
  });

  List<ShedStock> get sheds => items;

  @override
  Future<List<ShedStock>> fetchItems() => getShed();

  Future<void> loadSheds() => loadItems();

  Future<bool> createShed({
    required String nome,
    required String locate,
    required int maxCapacity,
  }) async {
    final cleanName = nome.trim();
    final cleanLocate = locate.trim();
    final cleanMaxCapacity = maxCapacity;

    if (cleanName.isEmpty || cleanLocate.isEmpty || cleanMaxCapacity <= 0) {
      return false;
    }

    await addShed(
      nome: cleanName,
      locate: cleanLocate,
      maxCapacity: cleanMaxCapacity,
    );

    await loadSheds();
    return true;
  }

  Future<void> deleteShed(String id) async {
    await removeShed(id);

    await loadSheds();
  }

  Future<bool> editShed({
    required ShedStock shed,
    required String nome,
    required String locate,
    required int maxCapacity,
  }) async {
    final wasEdited = await editShedUseCase(
      shed: shed,
      nome: nome,
      locate: locate,
      maxCapacity: maxCapacity,
    );
    if (!wasEdited) return false;

    await loadSheds();
    return true;
  }
}
