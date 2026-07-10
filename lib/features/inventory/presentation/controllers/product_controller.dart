import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/services/stock_balance_calculator.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/edit_product.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/remove_product.dart';
import '../../domain/usecases/register_stock_movement.dart';
import 'collection_controller.dart';

class ProductController extends CollectionController<Product> {
  final GetProduct getProducts;
  final AddProduct addProduct;
  final CreateProduct createProductUseCase;
  final RemoveProduct removeProduct;
  final EditProduct editProductUseCase;
  final RegisterStockMovement registerStockMovementUseCase;

  ProductController({
    required this.getProducts,
    required this.addProduct,
    required this.createProductUseCase,
    required this.removeProduct,
    required this.editProductUseCase,
    required this.registerStockMovementUseCase,
  });

  List<Product> get products => items;
  List<StockMovement> movements = [];

  @override
  Future<List<Product>> fetchItems() => getProducts();

  Future<void> loadProducts() => loadItems();

  Future<void> createProduct({
    required String sku,
    required String nome,
    required String description,
    required String image,
    required double price,
    required String categoryName,
    String subcategoryName = '',
  }) async {
    final cleanSku = sku.trim();
    final cleanName = nome.trim();
    final cleanDescription = description.trim();
    final cleanImage = image.trim();
    final cleanPrice = price;

    if (cleanSku.isEmpty ||
        cleanName.isEmpty ||
        cleanDescription.isEmpty ||
        cleanPrice <= 0 ||
        categoryName.trim().isEmpty) {
      return;
    }

    await addProduct(
      sku: cleanSku,
      nome: cleanName,
      description: cleanDescription,
      image: cleanImage,
      price: cleanPrice,
      categoryName: categoryName.trim(),
      subcategoryName: subcategoryName.trim(),
    );

    await loadProducts();
  }

  Future<CreateProductResult> createProductFromForm({
    required String name,
    required String sku,
    required String description,
    required String imageUrl,
    required String priceText,
    required String? selectedCategoryId,
    required String? selectedSubcategoryName,
    required List<Category> categories,
    required String productNameRequiredMessage,
    required String productSkuRequiredMessage,
    required String productDescriptionRequiredMessage,
    required String invalidImageUrlMessage,
    required String invalidPriceMessage,
    required String priceGreaterThanZeroMessage,
    required String selectCategoryMessage,
    required String selectSubcategoryMessage,
  }) async {
    final result = await createProductUseCase(
      name: name,
      sku: sku,
      description: description,
      imageUrl: imageUrl,
      priceText: priceText,
      selectedCategoryId: selectedCategoryId,
      selectedSubcategoryName: selectedSubcategoryName,
      categories: categories,
      products: products,
      productNameRequiredMessage: productNameRequiredMessage,
      productSkuRequiredMessage: productSkuRequiredMessage,
      productDescriptionRequiredMessage: productDescriptionRequiredMessage,
      invalidImageUrlMessage: invalidImageUrlMessage,
      invalidPriceMessage: invalidPriceMessage,
      priceGreaterThanZeroMessage: priceGreaterThanZeroMessage,
      selectCategoryMessage: selectCategoryMessage,
      selectSubcategoryMessage: selectSubcategoryMessage,
    );

    if (result.isSuccess) {
      await loadProducts();
    }

    return result;
  }

  int stockForProduct(String productId) {
    return StockBalanceCalculator.calcularSaldoProduto(
      movements: movements,
      productId: productId,
    );
  }

  int stockForProductInShed(String productId, String shedId) {
    return StockBalanceCalculator.calcularSaldoProduto(
      movements: movements,
      productId: productId,
      shedId: shedId,
    );
  }

  int stockForProductInShedUntil(
    String productId,
    String shedId,
    DateTime date,
  ) {
    return StockBalanceCalculator.calcularSaldoProduto(
      movements: movements,
      productId: productId,
      shedId: shedId,
      until: date,
    );
  }

  int stockForShed(String shedId) {
    return StockBalanceCalculator.calcularSaldoGalpao(
      movements: movements,
      shedId: shedId,
    );
  }

  int stockForShedUntil(String shedId, DateTime date) {
    return StockBalanceCalculator.calcularSaldoGalpao(
      movements: movements,
      shedId: shedId,
      until: date,
    );
  }

  bool canRemoveStock({
    required String productId,
    required String shedId,
    required int quantity,
  }) {
    return StockBalanceCalculator.canRemoveStock(
      movements: movements,
      productId: productId,
      shedId: shedId,
      quantity: quantity,
    );
  }

  Future<bool> registerMovement({
    required String productId,
    required String observation,
    required String shedId,
    required String shedName,
    required int entryQuantity,
    required int exitQuantity,
    required DateTime createdAt,
  }) async {
    final movement = registerStockMovementUseCase(
      products: products,
      movements: movements,
      productId: productId,
      observation: observation,
      shedId: shedId,
      shedName: shedName,
      entryQuantity: entryQuantity,
      exitQuantity: exitQuantity,
      createdAt: createdAt,
    );

    if (movement == null) return false;

    movements = [movement, ...movements];
    notifyListeners();

    return true;
  }

  Future<void> deleteProduct(String id) async {
    await removeProduct(id);

    await loadProducts();
  }

  Future<void> editProduct({
    required Product product,
    required String sku,
    required String nome,
    required String description,
    required String image,
    required double price,
    required String categoryName,
    required String subcategoryName,
  }) async {
    final wasEdited = await editProductUseCase(
      product: product,
      sku: sku,
      nome: nome,
      description: description,
      image: image,
      price: price,
      categoryName: categoryName,
      subcategoryName: subcategoryName,
    );
    if (!wasEdited) return;

    await loadProducts();
  }
}
