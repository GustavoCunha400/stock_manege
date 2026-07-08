import '../../domain/entities/product.dart';
import '../../domain/repositories/estokar_product_repository.dart';

class EstokarProductMemoryRepository implements EstokarProductRepository {
  final List<Product> _products = [];

  @override
  Future<List<Product>> getProducts() async => List.from(_products);

  @override
  Future<void> addProduct(Product product) async => _products.add(product);

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((item) => item.id == product.id);
    if (index == -1) return;

    _products[index] = product;
  }

  @override
  Future<void> deleteProduct(String id) async =>
      _products.removeWhere((product) => product.id == id);
}

