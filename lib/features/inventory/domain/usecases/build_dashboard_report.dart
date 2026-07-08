import '../entities/dashboard_report.dart';
import '../entities/product.dart';
import '../entities/stock_movement.dart';

class BuildDashboardReport {
  DashboardReport call({
    required List<Product> products,
    required List<StockMovement> movements,
    required String uncategorizedLabel,
    int lowStockLimit = 5,
    DateTime? now,
  }) {
    final stockByProductId = _stockByProductId(movements);
    final totalStock = stockByProductId.values.fold<int>(
      0,
      (total, stock) => total + stock,
    );
    final totalStockValue = products.fold<double>(0, (total, product) {
      final stock = stockByProductId[product.id] ?? 0;
      return total + stock * product.price;
    });
    final totalEntries = movements.fold<int>(
      0,
      (total, movement) => total + movement.entryQuantity,
    );
    final totalExits = movements.fold<int>(
      0,
      (total, movement) => total + movement.exitQuantity,
    );

    return DashboardReport(
      registeredProducts: products.length,
      totalStock: totalStock,
      totalStockValue: totalStockValue,
      lowStockProducts: _lowStockProductSheds(movements, lowStockLimit),
      totalEntries: totalEntries,
      totalExits: totalExits,
      recentMovements: _recentMovementGroups(movements, now ?? DateTime.now()),
      exitsByProduct: _topItems(
        _sumByProduct(movements, (movement) => movement.exitQuantity),
      ),
      exitsByCategory: _topItems(
        _sumByCategory(
          products,
          movements,
          (movement) => movement.exitQuantity,
          uncategorizedLabel,
        ),
      ),
      stockByCategory: _topItems(
        _sumProductsByCategory(
          products,
          (product) => stockByProductId[product.id] ?? 0,
        ),
      ),
      stockValueByCategory: _topItems(
        _sumProductsByCategory(
          products,
          (product) => (stockByProductId[product.id] ?? 0) * product.price,
        ),
      ),
    );
  }

  Map<String, int> _stockByProductId(List<StockMovement> movements) {
    final values = <String, int>{};
    for (final movement in movements) {
      values.update(
        movement.productId,
        (current) => current + movement.entryQuantity - movement.exitQuantity,
        ifAbsent: () => movement.entryQuantity - movement.exitQuantity,
      );
    }
    return values;
  }

  int _lowStockProductSheds(List<StockMovement> movements, int lowStockLimit) {
    final values = <String, int>{};
    for (final movement in movements) {
      final key = '${movement.productId}:${movement.shedId}';
      values.update(
        key,
        (current) => current + movement.entryQuantity - movement.exitQuantity,
        ifAbsent: () => movement.entryQuantity - movement.exitQuantity,
      );
    }

    return values.values
        .where((stock) => stock > 0 && stock <= lowStockLimit)
        .length;
  }

  Map<String, double> _sumByProduct(
    List<StockMovement> movements,
    int Function(StockMovement movement) quantitySelector,
  ) {
    final values = <String, double>{};
    for (final movement in movements) {
      final quantity = quantitySelector(movement);
      if (quantity <= 0) continue;
      values.update(
        movement.productName,
        (current) => current + quantity,
        ifAbsent: () => quantity.toDouble(),
      );
    }
    return values;
  }

  Map<String, double> _sumByCategory(
    List<Product> products,
    List<StockMovement> movements,
    int Function(StockMovement movement) quantitySelector,
    String uncategorizedLabel,
  ) {
    final categoriesByProductId = {
      for (final product in products) product.id: product.categoryName,
    };
    final values = <String, double>{};
    for (final movement in movements) {
      final quantity = quantitySelector(movement);
      if (quantity <= 0) continue;
      final category = categoriesByProductId[movement.productId];
      final label = category == null || category.trim().isEmpty
          ? uncategorizedLabel
          : category;
      values.update(
        label,
        (current) => current + quantity,
        ifAbsent: () => quantity.toDouble(),
      );
    }
    return values;
  }

  Map<String, double> _sumProductsByCategory(
    List<Product> products,
    num Function(Product product) valueSelector,
  ) {
    final values = <String, double>{};
    for (final product in products) {
      final value = valueSelector(product).toDouble();
      if (value <= 0) continue;
      values.update(
        product.categoryName,
        (current) => current + value,
        ifAbsent: () => value,
      );
    }
    return values;
  }

  List<DashboardChartItem> _recentMovementGroups(
    List<StockMovement> movements,
    DateTime now,
  ) {
    final today = DateTime(now.year, now.month, now.day);
    final days = List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      return DateTime(date.year, date.month, date.day);
    });

    final entriesByDay = <DateTime, int>{for (final day in days) day: 0};
    final exitsByDay = <DateTime, int>{for (final day in days) day: 0};

    for (final movement in movements) {
      final movementDay = DateTime(
        movement.createdAt.year,
        movement.createdAt.month,
        movement.createdAt.day,
      );
      if (!entriesByDay.containsKey(movementDay)) continue;

      entriesByDay[movementDay] =
          entriesByDay[movementDay]! + movement.entryQuantity;
      exitsByDay[movementDay] = exitsByDay[movementDay]! + movement.exitQuantity;
    }

    return [
      for (final day in days)
        DashboardChartItem(
          label:
              '${day.day.toString().padLeft(2, '0')}'
              '/${day.month.toString().padLeft(2, '0')}',
          value: entriesByDay[day]!.toDouble(),
          secondaryValue: exitsByDay[day]!.toDouble(),
        ),
    ];
  }

  List<DashboardChartItem> _topItems(
    Map<String, double> values, {
    int limit = 5,
  }) {
    final items =
        values.entries
            .map(
              (entry) =>
                  DashboardChartItem(label: entry.key, value: entry.value),
            )
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    return items.take(limit).toList();
  }
}

