class DashboardReport {
  final int registeredProducts;
  final int totalStock;
  final double totalStockValue;
  final int lowStockProducts;
  final int totalEntries;
  final int totalExits;
  final List<DashboardChartItem> recentMovements;
  final List<DashboardChartItem> exitsByProduct;
  final List<DashboardChartItem> exitsByCategory;
  final List<DashboardChartItem> stockByCategory;
  final List<DashboardChartItem> stockValueByCategory;

  const DashboardReport({
    required this.registeredProducts,
    required this.totalStock,
    required this.totalStockValue,
    required this.lowStockProducts,
    required this.totalEntries,
    required this.totalExits,
    required this.recentMovements,
    required this.exitsByProduct,
    required this.exitsByCategory,
    required this.stockByCategory,
    required this.stockValueByCategory,
  });
}

class DashboardChartItem {
  final String label;
  final double value;
  final double secondaryValue;

  const DashboardChartItem({
    required this.label,
    required this.value,
    this.secondaryValue = 0,
  });
}

