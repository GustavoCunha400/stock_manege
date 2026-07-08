import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_category_repository.dart';

class RemoveCategory {
  final EstokarCategoryRepository repository;

  RemoveCategory(this.repository);

  Future<void> call(String id) async => repository.deleteCategory(id);
}

