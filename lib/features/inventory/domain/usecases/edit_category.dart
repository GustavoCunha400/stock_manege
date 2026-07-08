import '../entities/category.dart';
import '../entities/subcategory.dart';
import '../repositories/estokar_category_repository.dart';
import '../services/id_generator.dart';

class EditCategory {
  final EstokarCategoryRepository repository;
  final IdGenerator idGenerator;

  EditCategory(this.repository, this.idGenerator);

  Future<bool> call({
    required Category category,
    required String name,
    required String description,
    required List<String> subcategoryNames,
  }) async {
    final cleanName = name.trim();
    final cleanDescription = description.trim();

    if (cleanName.isEmpty || cleanDescription.isEmpty) {
      return false;
    }

    final updatedCategory = category.copyWith(
      name: cleanName,
      description: cleanDescription,
      subcategories: subcategoryNames
          .map((subcategoryName) => subcategoryName.trim())
          .where((subcategoryName) => subcategoryName.isNotEmpty)
          .map(
            (subcategoryName) => Subcategory(
              id: idGenerator.generate(),
              categoryId: category.id,
              name: subcategoryName,
              description: '',
            ),
          )
          .toList(),
    );

    await repository.updateCategory(updatedCategory);
    return true;
  }
}

