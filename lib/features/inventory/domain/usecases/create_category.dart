import '../entities/category.dart';
import '../repositories/estokar_category_repository.dart';
import '../services/id_generator.dart';

class CreateCategory {
  final EstokarCategoryRepository repository;
  final IdGenerator idGenerator;

  CreateCategory(this.repository, this.idGenerator);

  Future<void> call({required String nome, required String description}) async {
    final category = Category(
      id: idGenerator.generate(),
      name: nome,
      description: description,
      subcategories: [],
    );
    return repository.addCategory(category);
  }
}

