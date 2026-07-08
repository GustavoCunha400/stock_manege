import 'package:estokar_gestaodeestoque/features/inventory/domain/repositories/estokar_product_repository.dart';

import '../entities/product.dart';
import '../services/id_generator.dart';

class AddProduct {
  final EstokarProductRepository repository;
  final IdGenerator idGenerator;

  AddProduct(this.repository, this.idGenerator);

  Future<void> call({
    required String sku,
    required String nome,
    required String description,
    required String image,
    required double price,
    required String categoryName,
    required String subcategoryName,
  }) async {
    final product = Product(
      id: idGenerator.generate(),
      sku: sku,
      nome: nome,
      description: description,
      image: image,
      price: price,
      categoryName: categoryName,
      subcategoryName: subcategoryName,
    );
    return repository.addProduct(product);
  }
}

