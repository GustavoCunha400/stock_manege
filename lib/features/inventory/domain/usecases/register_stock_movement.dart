import '../entities/product.dart';
import '../entities/stock_movement.dart';
import '../services/stock_balance_calculator.dart';

class RegisterStockMovement {
  StockMovement? call({
    required List<Product> products,
    required List<StockMovement> movements,
    required String productId,
    required String observation,
    required String shedId,
    required String shedName,
    required int entryQuantity,
    required int exitQuantity,
    required DateTime createdAt,
  }) {
    final product = products.where((product) => product.id == productId).firstOrNull;
    if (product == null) return null;

    final previousStock = StockBalanceCalculator.calcularSaldoProduto(
      movements: movements,
      productId: productId,
      shedId: shedId,
      until: createdAt,
    );

    final movement = StockMovement(
      productId: product.id,
      productName: product.nome,
      observation: observation,
      shedId: shedId,
      shedName: shedName,
      unitPrice: product.price,
      entryQuantity: entryQuantity,
      exitQuantity: exitQuantity,
      resultingStock: previousStock + entryQuantity - exitQuantity,
      createdAt: createdAt,
    );

    final validation = StockBalanceCalculator.validateStockMovement(
      movements: movements,
      candidate: movement,
    );

    return validation.isValid ? movement : null;
  }
}
