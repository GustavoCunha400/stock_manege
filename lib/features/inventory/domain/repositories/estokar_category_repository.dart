import '../entities/category.dart';

abstract class EstokarCategoryRepository {
  Future<List<Category>> getCategories();

  Future<void> addCategory(Category category);

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(String id);
}

