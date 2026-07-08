import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/product.dart';
import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_product_repository.dart';

class UpdateProduct {
  final EstokarProductRepository repository;

  UpdateProduct(this.repository);

  Future<void> call(Product product) async {
    return repository.updateProduct(product);
  }
}

