import '../entities/product.dart';
import '../repositories/estokar_product_repository.dart';

class EditProduct {
  final EstokarProductRepository repository;

  EditProduct(this.repository);

  Future<bool> call({
    required Product product,
    required String sku,
    required String nome,
    required String description,
    required String image,
    required double price,
    required String categoryName,
    required String subcategoryName,
  }) async {
    final cleanSku = sku.trim();
    final cleanName = nome.trim();
    final cleanDescription = description.trim();
    final cleanImage = image.trim();
    final cleanCategoryName = categoryName.trim();
    final cleanSubcategoryName = subcategoryName.trim();

    if (cleanSku.isEmpty ||
        cleanName.isEmpty ||
        cleanDescription.isEmpty ||
        price <= 0 ||
        cleanCategoryName.isEmpty ||
        cleanSubcategoryName.isEmpty) {
      return false;
    }

    await repository.updateProduct(
      product.copyWith(
        sku: cleanSku,
        nome: cleanName,
        description: cleanDescription,
        image: cleanImage,
        price: price,
        categoryName: cleanCategoryName,
        subcategoryName: cleanSubcategoryName,
      ),
    );
    return true;
  }
}

