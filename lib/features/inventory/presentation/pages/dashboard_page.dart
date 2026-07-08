import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart' hide Card;
import 'package:flutter/material.dart' hide Colors, Tooltip;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:estokar_gestaodeestoque/features/inventory/presentation/controllers/low_stock_settings_controller.dart';

import '../../../../app/app_breakpoints.dart';
import '../../../../core/theme/controllers/theme_controller.dart';
import '../../../../core/utils/colorful_page_header.dart';
import '../../../../core/utils/responsive_text_overflow.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/dashboard_report.dart';
import '../../domain/usecases/build_dashboard_report.dart';
import '../controllers/product_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const _entryColor = Color(0xFF246BFE);
  static const _exitColor = Color(0xFFEF4444);
  static const _stockColor = Color(0xFF00A889);
  static const _warningColor = Color(0xFFFFB020);
  static const _chartColors = [
    Color(0xFF246BFE),
    Color(0xFF00A889),
    Color(0xFFFFB020),
    Color(0xFFEF4444),
    Color(0xFF7C3AED),
    Color(0xFF0891B2),
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProductController>();
      if (controller.products.isEmpty && !controller.isLoading) {
        controller.loadProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productController = context.watch<ProductController>();
    final lowStockLimit = context.watch<LowStockSettingsController>().limit;
    final report = context.read<BuildDashboardReport>()(
      products: productController.products,
      movements: productController.movements,
      uncategorizedLabel: l10n.uncategorized,
      lowStockLimit: lowStockLimit,
    );
    final isDarkTheme =
        context.watch<ThemeController>().themeMode == ThemeMode.dark;
    final moneyFormatter = NumberFormat.simpleCurrency(
      locale: l10n.localeName,
      name: 'BRL',
    );
    final isMobile = context.isMobile;
    final pagePadding = isMobile
        ? const EdgeInsets.fromLTRB(6, 0, 6, 10)
        : const EdgeInsets.fromLTRB(16, 0, 16, 24);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: pagePadding,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColorfulPageHeader(
                  title: l10n.dashboard,
                  icon: Icons.bar_chart,
                  isDarkTheme: isDarkTheme,
                ),
              ],
            ),
            SizedBox(height: isMobile ? 6 : 12),
            Visibility(
              visible: false,
              child: SizedBox(
                width: 260,
                child: DropdownButtonFormField<int>(
                  value: lowStockLimit,
                  decoration: InputDecoration(
                    labelText: l10n.lowStockLimit,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    for (final limit in [lowStockLimit])
                      DropdownMenuItem(
                        value: limit,
                        child: Text(l10n.upToUnits(limit.toString())),
                      ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                  },
                ),
              ),
            ),
            SizedBox(height: isMobile ? 6 : 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = context.isMobile
                    ? 2
                    : constraints.maxWidth >= AppBreakpoints.tablet
                    ? 4
                    : 2;
                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: isMobile ? 6 : 12,
                  mainAxisSpacing: isMobile ? 6 : 12,
                  childAspectRatio: isMobile ? 1.75 : columns == 4 ? 2.4 : 1.7,
                  children: [
                    _MetricCard(
                      title: l10n.registeredProducts,
                      value: '${report.registeredProducts}',
                      icon: Icons.inventory_2_outlined,
                      color: _entryColor,
                      onTap: () => context.go('/stock'),
                    ),
                    _MetricCard(
                      title: l10n.stockItems,
                      value: '${report.totalStock}',
                      icon: Icons.warehouse_outlined,
                      color: _stockColor,
                      onTap: () => context.go('/shed'),
                    ),
                    _MetricCard(
                      title: l10n.totalStockValue,
                      value: moneyFormatter.format(report.totalStockValue),
                      icon: Icons.payments_outlined,
                      color: _warningColor,
                    ),
                    _MetricCard(
                      title: l10n.lowStock,
                      value: '${report.lowStockProducts}',
                      icon: Icons.report_problem_outlined,
                      color: _exitColor,
                      onTap: () => context.go('/stock?filter=low_stock'),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: isMobile ? 6 : 16),
            if (isMobile)
              Column(
                children: [
                  _MetricSummaryCard(
                      title: l10n.totalEntries,
                      value: '${report.totalEntries}',
                      icon: Icons.call_received,
                      color: _entryColor,
                  ),
                  const SizedBox(height: 6),
                  _MetricSummaryCard(
                    title: l10n.totalExits,
                    value: '${report.totalExits}',
                    icon: Icons.call_made,
                    color: _exitColor,
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _MetricSummaryCard(
                      title: l10n.totalEntries,
                      value: '${report.totalEntries}',
                      icon: Icons.call_received,
                      color: _entryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricSummaryCard(
                      title: l10n.totalExits,
                      value: '${report.totalExits}',
                      icon: Icons.call_made,
                      color: _exitColor,
                    ),
                  ),
                ],
              ),
            SizedBox(height: isMobile ? 6 : 16),
            _ChartCard(
              title: l10n.recentMovements,
              subtitle: l10n.recentMovementsSubtitle,
              height: isMobile ? 180 : 280,
              child: report.recentMovements.isEmpty
                  ? _EmptyChart(message: l10n.noRecentMovements)
                  : _MovementBarChart(
                      items: report.recentMovements,
                      entryLabel: l10n.entry,
                      exitLabel: l10n.exit,
                    ),
            ),
            SizedBox(height: isMobile ? 6 : 16),
            _ResponsiveCharts(
              children: [
                _ChartCard(
                  title: l10n.topExitProducts,
                  subtitle: l10n.topExitProductsSubtitle,
                  height: isMobile ? 240 : 300,
                  child: report.exitsByProduct.isEmpty
                      ? _EmptyChart(message: l10n.noProductExits)
                      : _HorizontalBarChart(
                          items: report.exitsByProduct,
                          color: _exitColor,
                          totalValue: report.totalExits.toDouble(),
                          valueFormatter: (value) => value.toInt().toString(),
                        ),
                ),
                _ChartCard(
                  title: l10n.topExitCategories,
                  subtitle: l10n.topExitCategoriesSubtitle,
                  height: isMobile ? 185 : 300,
                  child: report.exitsByCategory.isEmpty
                      ? _EmptyChart(message: l10n.noCategoryExits)
                      : _DonutChart(items: report.exitsByCategory),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 6 : 16),
            _ResponsiveCharts(
              children: [
                _ChartCard(
                  title: l10n.stockByCategory,
                  subtitle: l10n.stockByCategorySubtitle,
                  height: isMobile ? 185 : 300,
                  child: report.stockByCategory.isEmpty
                      ? _EmptyChart(message: l10n.noCategoryStock)
                      : _HorizontalBarChart(
                          items: report.stockByCategory,
                          color: _stockColor,
                          totalValue: report.totalStock.toDouble(),
                          valueFormatter: (value) => value.toInt().toString(),
                        ),
                ),
                _ChartCard(
                  title: l10n.stockValueByCategory,
                  subtitle: l10n.stockValueByCategorySubtitle,
                  height: isMobile ? 185 : 300,
                  child: report.stockValueByCategory.isEmpty
                      ? _EmptyChart(message: l10n.noStockValue)
                      : _HorizontalBarChart(
                          items: report.stockValueByCategory,
                          color: _warningColor,
                          totalValue: report.totalStockValue,
                          valueFormatter: moneyFormatter.format,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isMobile ? 10 : 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 170;
            final padding = isCompact ? 8.0 : isMobile ? 10.0 : 16.0;
            final valueFontSize = (constraints.maxHeight * 0.26).clamp(
              isMobile ? 16.0 : 20.0,
              isMobile ? 24.0 : 30.0,
            );
            final valueScale = (valueFontSize / (isMobile ? 28.0 : 34.0))
                .clamp(0.85, 1.15);
            final iconSize = ((constraints.maxWidth * 0.12) * valueScale)
                .clamp(
              isMobile ? 14.0 : 18.0,
              isMobile ? 28.0 : 36.0,
            );
            final titleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ((constraints.maxWidth * 0.065) * valueScale).clamp(
                    isMobile ? 10.0 : 11.0,
                    isMobile ? 14.0 : 16.0,
                  ),
                  height: 1.08,
                  fontWeight: FontWeight.w600,
                );
            final valueStyle = Theme.of(context).textTheme.headlineMedium
                ?.copyWith(
                  fontSize: valueFontSize,
                  height: 1,
                  fontWeight: FontWeight.w800,
                );

            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon, color: color, size: iconSize),
                      SizedBox(width: isCompact ? 5 : 8),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: responsiveTextOverflow(context),
                          style: titleStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isCompact ? 4 : 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          alignment: Alignment.bottomLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(value, style: valueStyle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetricSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricSummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Card(
      elevation: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;
          final padding = isCompact ? 8.0 : isMobile ? 10.0 : 16.0;
          final valueFontSize = (constraints.maxWidth * 0.06).clamp(
            isMobile ? 18.0 : 22.0,
            isMobile ? 28.0 : 34.0,
          );
          final valueScale = (valueFontSize / (isMobile ? 24.0 : 30.0))
              .clamp(0.85, 1.12);
          final avatarRadius = ((constraints.maxWidth * 0.045) * valueScale)
              .clamp(
            isMobile ? 15.0 : 18.0,
            isMobile ? 24.0 : 32.0,
          );
          final valueStyle = Theme.of(context).textTheme.headlineSmall
              ?.copyWith(
                fontSize: valueFontSize,
                height: 1,
                fontWeight: FontWeight.w800,
                color: color,
              );
          final titleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ((constraints.maxWidth * 0.032) * valueScale).clamp(
                  isMobile ? 11.0 : 12.0,
                  isMobile ? 15.0 : 16.0,
                ),
                height: 1.08,
              );

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color, size: avatarRadius * 1.12),
                ),
                SizedBox(width: isCompact ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(value, style: valueStyle),
                        ),
                      ),
                      SizedBox(height: isCompact ? 3 : 5),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: responsiveTextOverflow(context),
                        style: titleStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double height;
  final Widget child;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: isMobile ? 6 : 16),
            SizedBox(height: height, child: child),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveCharts extends StatelessWidget {
  final List<Widget> children;

  const _ResponsiveCharts({
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 760) {
          return Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) const SizedBox(height: 10),
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              Expanded(child: children[index]),
              if (index != children.length - 1) const SizedBox(width: 16),
            ],
          ],
        );
      },
    );
  }
}

class _MovementBarChart extends StatelessWidget {
  final List<DashboardChartItem> items;
  final String entryLabel;
  final String exitLabel;

  const _MovementBarChart({
    required this.items,
    required this.entryLabel,
    required this.exitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final maxValue = items.fold<double>(
      0,
      (max, item) => math.max(max, math.max(item.value, item.secondaryValue)),
    );
    final chartMaxY = _roundedMovementChartMaxY(maxValue);

    return BarChart(
      BarChartData(
        maxY: chartMaxY,
        alignment: isMobile
            ? BarChartAlignment.spaceBetween
            : BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) =>
                Theme.of(context).colorScheme.inverseSurface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = rodIndex == 0 ? entryLabel : exitLabel;
              return BarTooltipItem(
                '$label\n${rod.toY.toInt()}',
                TextStyle(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isMobile ? 38 : 46,
              interval: chartMaxY / 4,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value > meta.max) {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    _formatMovementAxisValue(value),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: isMobile ? 46 : 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= items.length) {
                  return const SizedBox.shrink();
                }
                final label = isMobile
                    ? items[index].label.replaceFirst('/', '\n')
                    : items[index].label;
                return SideTitleWidget(
                  meta: meta,
                  space: isMobile ? 12 : 8,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: isMobile ? 10 : null,
                      height: isMobile ? 1.05 : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: chartMaxY / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
            strokeWidth: 1,
          ),
        ),
        barGroups: [
          for (var index = 0; index < items.length; index++)
            BarChartGroupData(
              x: index,
              barsSpace: isMobile ? 4 : 6,
              barRods: [
                BarChartRodData(
                  toY: items[index].value,
                  color: _DashboardPageState._entryColor,
                  width: isMobile ? 9 : 12,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: items[index].secondaryValue,
                  color: _DashboardPageState._exitColor,
                  width: isMobile ? 9 : 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static double _roundedMovementChartMaxY(double maxValue) {
    if (maxValue <= 0) return 1;
    if (maxValue >= 1000) {
      return (maxValue / 1000).ceilToDouble() * 1000;
    }

    final magnitude = math
        .pow(10, maxValue.floor().toString().length - 1)
        .toDouble();
    return (maxValue / magnitude).ceilToDouble() * magnitude;
  }

  static String _formatMovementAxisValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.', ',')}K';
    }
    return value.round().toString();
  }
}

class _HorizontalBarChart extends StatelessWidget {
  final List<DashboardChartItem> items;
  final Color color;
  final double totalValue;
  final String Function(double value) valueFormatter;

  const _HorizontalBarChart({
    required this.items,
    required this.color,
    required this.totalValue,
    required this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final itemGap = isMobile ? 10.0 : 12.0;
    final valueWidth = isMobile ? 70.0 : 104.0;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          height: 1.15,
          fontWeight: FontWeight.w600,
        );

    return SingleChildScrollView(
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            Builder(
              builder: (context) {
                final item = items[index];
                final progress = totalValue <= 0
                    ? 0.0
                    : (item.value / totalValue).clamp(0.0, 1.0);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Tooltip(
                            message: item.label,
                            child: Text(
                              item.label,
                              maxLines: 2,
                              overflow: responsiveTextOverflow(context),
                              style: labelStyle,
                            ),
                          ),
                        ),
                        SizedBox(width: itemGap),
                        SizedBox(
                          width: valueWidth,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              valueFormatter(item.value),
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: isMobile ? 9 : 10,
                        value: progress,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                );
              },
            ),
            if (index != items.length - 1) SizedBox(height: itemGap),
          ],
        ],
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  final List<DashboardChartItem> items;

  const _DonutChart({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final total = items.fold<double>(0, (sum, item) => sum + item.value);
    final isMobile = context.isMobile;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxChartSize = math.min(
          constraints.maxHeight,
          constraints.maxWidth * (isMobile ? 0.34 : 0.38),
        );
        final chartSize = maxChartSize.clamp(96.0, isMobile ? 124.0 : 168.0);
        final sectionRadius = chartSize * 0.28;
        final centerSpaceRadius = chartSize * 0.22;

        return Row(
          children: [
            SizedBox.square(
              dimension: chartSize,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: centerSpaceRadius,
                  sectionsSpace: 2,
                  sections: [
                    for (var index = 0; index < items.length; index++)
                      PieChartSectionData(
                        value: items[index].value,
                        color:
                            _DashboardPageState._chartColors[index %
                                _DashboardPageState._chartColors.length],
                        radius: sectionRadius,
                        title: total == 0
                            ? ''
                            : '${(items[index].value / total * 100).round()}%',
                        titleStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: isMobile ? 10 : 12,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: isMobile ? 8 : 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color:
                                _DashboardPageState._chartColors[index %
                                    _DashboardPageState._chartColors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${items[index].label} (${items[index].value.toInt()})',
                            maxLines: 1,
                            overflow: responsiveTextOverflow(context),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyChart extends StatelessWidget {
  final String message;

  const _EmptyChart({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insights_outlined,
            color: Theme.of(context).disabledColor,
            size: 42,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).disabledColor),
          ),
        ],
      ),
    );
  }
}
