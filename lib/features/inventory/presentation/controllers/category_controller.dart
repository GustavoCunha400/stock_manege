import 'package:fluent_ui/fluent_ui.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/edit_category.dart';
import '../../domain/usecases/get_category.dart';
import '../../domain/usecases/remove_category.dart';
import '../../domain/usecases/update_category.dart';

class CategoryController extends ChangeNotifier {
  final GetCategory getCategory;
  final AddCategory addCategory;
  final RemoveCategory removeCategory;
  final UpdateCategory updateCategory;
  final EditCategory editCategoryUseCase;

  CategoryController({
    required this.getCategory,
    required this.addCategory,
    required this.removeCategory,
    required this.updateCategory,
    required this.editCategoryUseCase,
    required this.categories,
    required this.isLoading,
  });

  List<Category> categories = [];

  bool isLoading = false;

  Future<void> loadCategory() async {
    isLoading = true;
    notifyListeners();

    categories = await getCategory();

    isLoading = false;
    notifyListeners();
  }

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

