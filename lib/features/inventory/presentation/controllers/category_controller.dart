import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/edit_category.dart';
import '../../domain/usecases/get_category.dart';
import '../../domain/usecases/remove_category.dart';
import 'collection_controller.dart';

class CategoryController extends CollectionController<Category> {
  final GetCategory getCategory;
  final AddCategory addCategory;
  final RemoveCategory removeCategory;
  final EditCategory editCategoryUseCase;

  CategoryController({
    required this.getCategory,
    required this.addCategory,
    required this.removeCategory,
    required this.editCategoryUseCase,
  });

  List<Category> get categories => items;

  @override
  Future<List<Category>> fetchItems() => getCategory();

  Future<void> loadCategory() => loadItems();

  Future<void> createCategory({
    required String nome,
    required String description,
    required List<String> subcategories,
  }) async {
    final cleanName = nome.trim();
    final cleanDescription = description.trim();

    if (cleanName.isEmpty || cleanDescription.isEmpty) {
      return;
    }

    await addCategory(
      name: cleanName,
      description: cleanDescription,
      subcategoryNames: subcategories,
    );

    await loadCategory();
  }

  Future<void> deleteCategory(String id) async {
    await removeCategory(id);

    await loadCategory();
  }

  Future<void> editCategory({
    required Category category,
    required String nome,
    required String description,
    required List<String> subcategories,
  }) async {
    final wasEdited = await editCategoryUseCase(
      category: category,
      name: nome,
      description: description,
      subcategoryNames: subcategories,
    );
    if (!wasEdited) return;

    await loadCategory();
  }
}
