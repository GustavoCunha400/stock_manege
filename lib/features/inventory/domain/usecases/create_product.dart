import '../entities/category.dart';
import '../entities/product.dart';
import 'add_product.dart';

class CreateProductResult {
  final bool isSuccess;
  final List<String> errors;

  const CreateProductResult._({
    required this.isSuccess,
    required this.errors,
  });

  const CreateProductResult.success()
    : this._(isSuccess: true, errors: const []);

  const CreateProductResult.failure(List<String> errors)
    : this._(isSuccess: false, errors: errors);
}

class CreateProduct {
  final AddProduct addProduct;

  CreateProduct(this.addProduct);

  Future<CreateProductResult> call({
    required String name,
    required String sku,
    required String description,
    required String imageUrl,
    required String priceText,
    required String? selectedCategoryId,
    required String? selectedSubcategoryName,
    required List<Category> categories,
    required List<Product> products,
    required String productNameRequiredMessage,
    required String productSkuRequiredMessage,
    required String productDescriptionRequiredMessage,
    required String invalidImageUrlMessage,
    required String invalidPriceMessage,
    required String priceGreaterThanZeroMessage,
    required String selectCategoryMessage,
    required String selectSubcategoryMessage,
  }) async {
    final cleanName = name.trim();
    final cleanSku = sku.trim();
    final cleanDescription = description.trim();
    final cleanImageUrl = imageUrl.trim();
    final price = double.tryParse(priceText.replaceAll(',', '.'));
    final category = categories
        .where((category) => category.id == selectedCategoryId)
        .firstOrNull;
    final errors = <String>[];

    if (cleanName.isEmpty) {
      errors.add(productNameRequiredMessage);
    }

    if (cleanSku.isEmpty) {
      errors.add(productSkuRequiredMessage);
    }

    if (cleanDescription.isEmpty) {
      errors.add(productDescriptionRequiredMessage);
    }

    if (cleanImageUrl.isNotEmpty && !_isValidImageUrl(cleanImageUrl)) {
      errors.add(invalidImageUrlMessage);
    }

    if (price == null) {
      errors.add(invalidPriceMessage);
    } else if (price <= 0) {
      errors.add(priceGreaterThanZeroMessage);
    }

    if (category == null) {
      errors.add(selectCategoryMessage);
    }

    if (errors.isNotEmpty) {
      return CreateProductResult.failure(errors);
    }

    await addProduct(
      nome: cleanName,
      sku: cleanSku,
      description: cleanDescription,
      image: cleanImageUrl,
      price: price!,
      categoryName: category!.name,
      subcategoryName: selectedSubcategoryName?.trim() ?? '',
    );

    return const CreateProductResult.success();
  }

  bool _isValidImageUrl(String value) {
    final uri = Uri.tryParse(value);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}

