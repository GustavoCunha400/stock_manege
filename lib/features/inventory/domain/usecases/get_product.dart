import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/product.dart';
import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_product_repository.dart';

class GetProduct {
  final EstokarProductRepository repository;

  GetProduct(this.repository);

  Future<List<Product>> call() async => repository.getProducts();
}
