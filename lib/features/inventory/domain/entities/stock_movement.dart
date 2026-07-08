class StockMovement {
  final String productId;
  final String productName;
  final String shedId;
  final String shedName;
  final double unitPrice;
  final int entryQuantity;
  final int exitQuantity;
  final int resultingStock;
  final DateTime createdAt;
  final String observation;

  StockMovement({
    required this.productId,
    required this.productName,
    required this.shedId,
    required this.shedName,
    required this.unitPrice,
    required this.entryQuantity,
    required this.exitQuantity,
    required this.resultingStock,
    required this.createdAt,
    required this.observation,
  });
}

