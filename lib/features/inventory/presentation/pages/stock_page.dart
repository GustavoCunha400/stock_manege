import 'package:fluent_ui/fluent_ui.dart' show ProgressRing;
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:estokar_gestaodeestoque/core/theme/controllers/theme_controller.dart';
import 'package:estokar_gestaodeestoque/core/utils/dialog_input_decoration.dart';
import 'package:estokar_gestaodeestoque/features/inventory/presentation/controllers/product_controller.dart';
import 'package:estokar_gestaodeestoque/features/inventory/presentation/controllers/low_stock_settings_controller.dart';
import 'package:estokar_gestaodeestoque/core/utils/colorful_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../widgets/card_action_buttons.dart';
import '../widgets/product_image_preview.dart';
import '../dialogs/edit_item.dart';
import '../controllers/category_controller.dart';
import '../controllers/shed_controller.dart';
import '../dialogs/add_movimentation.dart';
import '../dialogs/stock_item_actions_dialog.dart';

class StockPage extends StatefulWidget {
  final String? initialFilter;

  const StockPage({super.key, this.initialFilter});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final TextEditingController entradaController = TextEditingController();
  final TextEditingController saidaController = TextEditingController();
  final TextEditingController observationController = TextEditingController();
  final TextEditingController lowStockLimitController = TextEditingController();
  String? selectedCategoryName;
  String? expandedProductId;
  String stockFilter = 'all';
  LowStockSettingsController? _lowStockSettingsController;

  @override
  void initState() {
    super.initState();
    _applyInitialFilter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        loadProdutos();
      }
    });
  }

  @override
  void didUpdateWidget(covariant StockPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFilter != widget.initialFilter) {
      setState(_applyInitialFilter);
    }
  }

  void _applyInitialFilter() {
    stockFilter = widget.initialFilter == 'low_stock' ? 'low_stock' : 'all';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<LowStockSettingsController>();
    if (_lowStockSettingsController == controller) return;

    _lowStockSettingsController?.removeListener(_syncLowStockLimitText);
    _lowStockSettingsController = controller;
    _syncLowStockLimitText();
    controller.addListener(_syncLowStockLimitText);
  }

  void _syncLowStockLimitText() {
    final limitText = _lowStockSettingsController?.limit.toString();
    if (limitText == null || lowStockLimitController.text == limitText) {
      return;
    }

    lowStockLimitController.text = limitText;
  }

  void _saveLowStockLimit(String value) {
    final limit = int.tryParse(value);
    if (limit == null || limit < 1) {
      setState(() {});
      return;
    }

    context.read<LowStockSettingsController>().setLimit(limit);
  }

  Future<void> loadProdutos() async {
    await Future.wait([
      context.read<ProductController>().loadProducts(),
      context.read<CategoryController>().loadCategory(),
      context.read<ShedController>().loadSheds(),
    ]);
  }

  @override
  void dispose() {
    entradaController.dispose();
    saidaController.dispose();
    observationController.dispose();
    _lowStockSettingsController?.removeListener(_syncLowStockLimitText);
    lowStockLimitController.dispose();
    super.dispose();
  }

  Future<void> addMovimentation() async {
    await context.read<AddMovimentation>()(
      context: context,
      entradaController: entradaController,
      saidaController: saidaController,
      isMounted: () => mounted,
      observationController: observationController,
    );
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productController = context.watch<ProductController>();
    final currentLowStockLimit =
        context.watch<LowStockSettingsController>().limit;
    final categoryController = context.watch<CategoryController>();
    final itens = productController.products;
    final filteredItens = itens.where((item) {
      final itemStock = productController.stockForProduct(item.id);
      final matchesCategory =
          selectedCategoryName == null ||
          item.categoryName == selectedCategoryName;
      final matchesStock =
          stockFilter == 'all' ||
          stockFilter == 'low_stock' &&
              itemStock > 0 &&
              itemStock <= currentLowStockLimit;

      return matchesCategory && matchesStock;
    }).toList();
    final isDarkTheme =
        context.watch<ThemeController>().themeMode == ThemeMode.dark;
    final isMobile = context.isMobile;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorfulPageHeader(
            title: l10n.stock,
            icon: Icons.inventory_2_outlined,
            isDarkTheme: isDarkTheme,
            mobileHeaderWidthFraction: 0.64,
            actions: itens.isEmpty
                ? null
                : Builder(
                    builder: (context) {
                      InputDecoration filterDecoration(String label) {
                        return dialogInputDecoration(context, label).copyWith(
                          isDense: isMobile,
                          contentPadding: isMobile
                              ? const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                )
                              : null,
                        );
                      }

                      final categoryField = DropdownButtonFormField<String?>(
                        value: selectedCategoryName,
                        isExpanded: true,
                        decoration: filterDecoration(l10n.category),
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text(l10n.allCategories),
                          ),
                          ...categoryController.categories.map(
                            (category) => DropdownMenuItem<String?>(
                              value: category.name,
                              child: Text(category.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCategoryName = value;
                          });
                        },
                      );
                      final stockField = DropdownButtonFormField<String>(
                        value: stockFilter,
                        isExpanded: true,
                        decoration: filterDecoration(l10n.stock),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(l10n.stock),
                          ),
                          DropdownMenuItem(
                            value: 'low_stock',
                            child: Text(l10n.lowStock),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            stockFilter = value;
                          });
                        },
                      );
                      final lowStockLimitField = TextField(
                        controller: lowStockLimitController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: filterDecoration(l10n.lowStockLimit),
                        onChanged: _saveLowStockLimit,
                      );

                      return Row(
                        children: [
                          Expanded(child: lowStockLimitField),
                          const SizedBox(width: 8),
                          Expanded(child: stockField),
                          const SizedBox(width: 8),
                          Expanded(child: categoryField),
                        ],
                      );
                    },
                  ),
            mobileActions: itens.isEmpty
                ? null
                : [
                    TextField(
                      controller: lowStockLimitController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: dialogInputDecoration(
                        context,
                        l10n.lowStockLimit,
                      ).copyWith(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      onChanged: _saveLowStockLimit,
                    ),
                    DropdownButtonFormField<String>(
                      value: stockFilter,
                      isExpanded: true,
                      decoration: dialogInputDecoration(
                        context,
                        l10n.stock,
                      ).copyWith(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text(l10n.stock),
                        ),
                        DropdownMenuItem(
                          value: 'low_stock',
                          child: Text(l10n.lowStock),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          stockFilter = value;
                        });
                      },
                    ),
                    Builder(
                      builder: (context) {
                        return DropdownButtonFormField<String?>(
                          value: selectedCategoryName,
                          isExpanded: true,
                          decoration: dialogInputDecoration(
                            context,
                            l10n.category,
                          ).copyWith(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text(l10n.allCategories),
                            ),
                            ...categoryController.categories.map(
                              (category) => DropdownMenuItem<String?>(
                                value: category.name,
                                child: Text(category.name),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedCategoryName = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
          ),
          if (productController.isLoading)
            const Expanded(child: Center(child: ProgressRing()))
          else if (itens.isEmpty)
            Center(child: Text(l10n.noProduct))
          else ...[
            Expanded(
              flex: 2,
              child: filteredItens.isEmpty
                  ? Center(child: Text(l10n.noProductInCategory))
                  : ListView.builder(
                      itemCount: filteredItens.length,
                      itemBuilder: (context, index) {
                        final item = filteredItens[index];
                        final itemStock = productController.stockForProduct(
                          item.id,
                        );
                        final productMovements = productController.movements
                            .where(
                              (movement) => movement.productId == item.id,
                            );
                        final totalEntries = productMovements.fold<int>(
                          0,
                          (total, movement) =>
                              total + movement.entryQuantity,
                        );
                        final totalExits = productMovements.fold<int>(
                          0,
                          (total, movement) => total + movement.exitQuantity,
                        );
                        final isLowStock =
                            itemStock > 0 &&
                            itemStock <= currentLowStockLimit;
                        final isExpanded = expandedProductId == item.id;
                        final categoryLine = item.subcategoryName.trim().isEmpty
                            ? item.categoryName
                            : '${item.categoryName} - ${item.subcategoryName}';
                        return Card(
                          margin: EdgeInsets.symmetric(
                            vertical: isMobile ? 2 : 6,
                            horizontal: isMobile ? 4 : 12,
                          ),
                          child: ExpansionTile(
                            dense: isMobile,
                            tilePadding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 8 : 16,
                              vertical: isMobile ? 0 : 2,
                            ),
                            initiallyExpanded: isExpanded,
                            onExpansionChanged: (expanded) {
                              setState(() {
                                expandedProductId = expanded ? item.id : null;
                              });
                            },
                            leading: ProductImagePreview(imageUrl: item.image),
                            title: Text(
                              item.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Text(
                              '${l10n.sku}: ${item.sku}\n$categoryLine',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 6 : 12,
                                    vertical: isMobile ? 3 : 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (isLowStock
                                            ? Colors.red
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary)
                                        .withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${l10n.stock}: $itemStock',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                CardActionButtons(
                                  onEdit: () async {
                                    await context.read<EditItem>()(
                                      context: context,
                                      item: item,
                                      isMounted: () => mounted,
                                    );
                                  },
                                  onDelete: () async {
                                    await context
                                        .read<StockItemActionsDialog>()(
                                      context: context,
                                      item: item,
                                      isMounted: () => mounted,
                                    );
                                  },
                                ),
                              ],
                            ),
                            childrenPadding: EdgeInsets.fromLTRB(
                              isMobile ? 8 : 16,
                              0,
                              isMobile ? 8 : 16,
                              isMobile ? 8 : 16,
                            ),
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final chipWidth = constraints.maxWidth >= 560
                                      ? (constraints.maxWidth - 16) / 3
                                      : constraints.maxWidth;

                                  return Wrap(
                                    spacing: 8,
                                    runSpacing: isMobile ? 6 : 8,
                                    children: [
                                      SizedBox(
                                        width: chipWidth,
                                        child: _StockProductQuantityChip(
                                          label: l10n.currentQuantity,
                                          value: itemStock,
                                          color: isLowStock
                                              ? Colors.red
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          icon: Icons.inventory_2_outlined,
                                        ),
                                      ),
                                      SizedBox(
                                        width: chipWidth,
                                        child: _StockProductQuantityChip(
                                          label: l10n.entryQuantity,
                                          value: totalEntries,
                                          color: Colors.green,
                                          icon: Icons.arrow_downward,
                                        ),
                                      ),
                                      SizedBox(
                                        width: chipWidth,
                                        child: _StockProductQuantityChip(
                                          label: l10n.exitQuantity,
                                          value: totalExits,
                                          color: Colors.red,
                                          icon: Icons.arrow_upward,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                  ),
              ),
          ],
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 4 : 8,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: addMovimentation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.sync_alt),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            l10n.addMovement,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _StockProductQuantityChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _StockProductQuantityChip({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 10,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: isMobile ? 14 : 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: isMobile ? 10 : 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$value',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
