import '../entities/category.dart';
import '../entities/subcategory.dart';
import '../repositories/estokar_category_repository.dart';
import '../services/id_generator.dart';

class AddCategory {
  final EstokarCategoryRepository repository;
  final IdGenerator idGenerator;

  AddCategory(this.repository, this.idGenerator);

  Future<void> call({
    required String name,
    required String description,
    List<String> subcategoryNames = const [],
  }) async {
    final categoryId = idGenerator.generate();
    final category = Category(
      id: categoryId,
      name: name,
      description: description,
      subcategories: subcategoryNames
          .where((subcategoryName) => subcategoryName.trim().isNotEmpty)
          .map(
            (subcategoryName) => Subcategory(
              id: idGenerator.generate(),
              categoryId: categoryId,
              name: subcategoryName.trim(),
              description: '',
            ),
          )
          .toList(),
    );
    return repository.addCategory(category);
  }
}

