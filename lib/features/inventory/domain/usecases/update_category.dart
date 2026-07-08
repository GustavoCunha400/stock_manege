import '../entities/category.dart';
import '../repositories/estokar_category_repository.dart';

class UpdateCategory {
  final EstokarCategoryRepository repository;

  UpdateCategory(this.repository);

  Future<void> call(Category category) async {
    return repository.updateCategory(category);
  }
}

