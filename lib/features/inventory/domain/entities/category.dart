import 'package:estokar_gestaodeestoque/features/inventory/domain/entities/subcategory.dart';

class Category {
  final String id;
  final String name;
  final String description;
  final List<Subcategory>? subcategories;

  Category({
    required this.id,
    required this.name,
    required this.description,
    this.subcategories,
  });

  Category copyWith({
    String? id,
    String? name,
    String? description,
    List<Subcategory>? subcategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}

