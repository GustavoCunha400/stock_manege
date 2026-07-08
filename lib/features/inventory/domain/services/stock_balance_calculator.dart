import '../entities/stock_movement.dart';

enum StockMovementValidationError {
  none,
  invalidQuantity,
  futureDate,
  insufficientStock,
}

class StockMovementValidationResult {
  final StockMovementValidationError error;

  const StockMovementValidationResult._(this.error);

  const StockMovementValidationResult.success()
    : this._(StockMovementValidationError.none);

  const StockMovementValidationResult.invalidQuantity()
    : this._(StockMovementValidationError.invalidQuantity);

  const StockMovementValidationResult.futureDate()
    : this._(StockMovementValidationError.futureDate);

  const StockMovementValidationResult.insufficientStock()
    : this._(StockMovementValidationError.insufficientStock);

  bool get isValid => error == StockMovementValidationError.none;
}

class StockBalanceCalculator {
  const StockBalanceCalculator._();

  static int calcularSaldoProduto({
    required Iterable<StockMovement> movements,
    required String productId,
    String? shedId,
    DateTime? until,
  }) {
    return _orderedMovements(movements)
        .where(
          (movement) =>
              movement.productId == productId &&
              (shedId == null || movement.shedId == shedId) &&
              (until == null || !_isAfterDay(movement.createdAt, until)),
        )
        .fold<int>(
          0,
          (total, movement) =>
              total + movement.entryQuantity - movement.exitQuantity,
        );
  }

  static int calcularSaldoGalpao({
    required Iterable<StockMovement> movements,
    required String shedId,
    DateTime? until,
  }) {
    return _orderedMovements(movements)
        .where(
          (movement) =>
              movement.shedId == shedId &&
              (until == null || !_isAfterDay(movement.createdAt, until)),
        )
        .fold<int>(
          0,
          (total, movement) =>
              total + movement.entryQuantity - movement.exitQuantity,
        );
  }

  static bool canRemoveStock({
    required Iterable<StockMovement> movements,
    required String productId,
    required String shedId,
    required int quantity,
    bool allowNegativeStock = false,
  }) {
    if (allowNegativeStock) return true;
    if (quantity <= 0) return false;

    final availableStock = calcularSaldoProduto(
      movements: movements,
      productId: productId,
      shedId: shedId,
    );
    return quantity <= availableStock;
  }

  static StockMovementValidationResult validateStockMovement({
    required Iterable<StockMovement> movements,
    required StockMovement candidate,
    DateTime? today,
    bool allowNegativeStock = false,
  }) {
    if (candidate.entryQuantity < 0 ||
        candidate.exitQuantity < 0 ||
        candidate.entryQuantity == 0 && candidate.exitQuantity == 0) {
      return const StockMovementValidationResult.invalidQuantity();
    }

    if (_isAfterDay(candidate.createdAt, today ?? DateTime.now())) {
      return const StockMovementValidationResult.futureDate();
    }

    if (!allowNegativeStock &&
        candidate.exitQuantity > 0 &&
        (!canRemoveStock(
              movements: movements,
              productId: candidate.productId,
              shedId: candidate.shedId,
              quantity: candidate.exitQuantity,
            ) ||
            !_keepsProductStockNonNegative(movements, candidate))) {
      return const StockMovementValidationResult.insufficientStock();
    }

    return const StockMovementValidationResult.success();
  }

  static List<StockMovement> _orderedMovements(
    Iterable<StockMovement> movements,
  ) {
    return movements.toList()
      ..sort((a, b) {
        final dateComparison = a.createdAt.compareTo(b.createdAt);
        if (dateComparison != 0) return dateComparison;

        return _sameDayPriority(a).compareTo(_sameDayPriority(b));
      });
  }

  static bool _keepsProductStockNonNegative(
    Iterable<StockMovement> movements,
    StockMovement candidate,
  ) {
    var stock = 0;
    final orderedMovements = _orderedMovements([
      ...movements.where(
        (movement) =>
            movement.productId == candidate.productId &&
            movement.shedId == candidate.shedId,
      ),
      candidate,
    ]);

    for (final movement in orderedMovements) {
      stock += movement.entryQuantity - movement.exitQuantity;
      if (stock < 0) return false;
    }

    return true;
  }
}

int _sameDayPriority(StockMovement movement) {
  if (movement.entryQuantity > 0 && movement.exitQuantity == 0) return 0;
  if (movement.entryQuantity > 0 && movement.exitQuantity > 0) return 1;
  return 2;
}

bool _isAfterDay(DateTime value, DateTime day) {
  final valueDay = DateTime(value.year, value.month, value.day);
  final targetDay = DateTime(day.year, day.month, day.day);
  return valueDay.isAfter(targetDay);
}
