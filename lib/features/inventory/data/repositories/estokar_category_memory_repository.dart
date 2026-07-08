import '../../domain/entities/category.dart';
import '../../domain/repositories/estokar_category_repository.dart';

class EstokarCategoryMemoryRepository implements EstokarCategoryRepository {
  final List<Category> _categories = [];

  @override
  Future<List<Category>> getCategories() async => List.from(_categories);

  @override
  Future<void> addCategory(Category category) async =>
      _categories.add(category);

  @override
  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((item) => item.id == category.id);
    if (index == -1) return;

    _categories[index] = category;
  }

  @override
  Future<void> deleteCategory(String id) async =>
      _categories.removeWhere((category) => category.id == id);
}

