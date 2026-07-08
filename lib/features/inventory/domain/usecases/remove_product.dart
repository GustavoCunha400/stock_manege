import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_product_repository.dart';

class RemoveProduct {
  final EstokarProductRepository repository;

  RemoveProduct(this.repository);

  Future<void> call(String id) async => repository.deleteProduct(id);
}

