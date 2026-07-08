import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/category.dart';
import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_category_repository.dart';

class GetCategory {
  final EstokarCategoryRepository repository;

  GetCategory(this.repository);

  Future<List<Category>> call() async => repository.getCategories();
}

