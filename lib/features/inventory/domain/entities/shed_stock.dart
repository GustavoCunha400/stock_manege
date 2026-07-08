class ShedStock {
  final String id;
  final String nome;
  final String locate;
  final int maxCapacity;

  ShedStock({
    required this.id,
    required this.nome,
    required this.locate,
    required this.maxCapacity,
  });

  ShedStock copyWith({
    String? id,
    String? nome,
    String? locate,
    int? maxCapacity,
  }) {
    return ShedStock(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      locate: locate ?? this.locate,
      maxCapacity: maxCapacity ?? this.maxCapacity,
    );
  }
}

