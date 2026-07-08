class Product {
  final String id;
  final String sku;
  final String nome;
  final String description;
  final String image;
  final double price;
  final String categoryName;
  final String subcategoryName;

  // ignore: ddc_missing_field_initialization
  Product({
    required this.id,
    required this.sku,
    required this.nome,
    required this.description,
    required this.image,
    required this.price,
    required this.categoryName,
    required this.subcategoryName,
  });

  Product copyWith({
    String? id,
    String? sku,
    String? nome,
    String? description,
    String? image,
    double? price,
    String? categoryName,
    String? subcategoryName,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      nome: nome ?? this.nome,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      categoryName: categoryName ?? this.categoryName,
      subcategoryName: subcategoryName ?? this.subcategoryName,
    );
  }
}

