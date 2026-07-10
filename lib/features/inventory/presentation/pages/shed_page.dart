import 'package:fluent_ui/fluent_ui.dart' show ProgressRing;
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:estokar_gestaodeestoque/core/theme/controllers/theme_controller.dart';
import 'package:estokar_gestaodeestoque/core/utils/colorful_page_header.dart';
import 'package:estokar_gestaodeestoque/core/utils/dialog_input_decoration.dart';
import 'package:estokar_gestaodeestoque/core/utils/responsive_text_overflow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../dialogs/create_shed_dialog.dart';
import '../dialogs/edit_shed_dialog.dart';
import '../dialogs/shed_actions_dialog.dart';
import '../dialogs/show_movimentation_dialog.dart';
import '../controllers/product_controller.dart';
import '../controllers/shed_controller.dart';
import '../../domain/usecases/product_image_preview.dart';

class ShedPage extends StatefulWidget {
  final String? initialFilter;
  final int? initialLowStockLimit;

  const ShedPage({super.key, this.initialFilter, this.initialLowStockLimit});

  @override
  State<ShedPage> createState() => _ShedPageState();
}

class _ShedPageState extends State<ShedPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locateController = TextEditingController();
  final TextEditingController maxCapacityController = TextEditingController();
  final TextEditingController citySearchController = TextEditingController();
  String availabilityFilter = 'all';
  String? expandedShedId;
  String? selectedCategoryName;
  String stockFilter = 'all';
  late int lowStockLimit;

  @override
  void initState() {
    super.initState();
    lowStockLimit = widget.initialLowStockLimit ?? 5;
    if (widget.initialFilter == 'low_stock') {
      availabilityFilter = 'low_stock';
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ShedController>().loadSheds();
        context.read<ProductController>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    locateController.dispose();
    maxCapacityController.dispose();
    citySearchController.dispose();
    super.dispose();
  }

  void _clearShedForm() {
    nameController.clear();
    locateController.clear();
    maxCapacityController.clear();
  }

  int usedCapacityForShed(String shedName) {
    final productController = context.read<ProductController>();
    final shed = context
        .read<ShedController>()
        .sheds
        .where((shed) => shed.nome == shedName)
        .firstOrNull;
    if (shed == null) return 0;

    return productController.stockForShed(shed.id);
  }

  Future<void> showMovimentations({
    required String shedId,
    required String shedName,
  }) async {
    await context.read<ShowMovimentationDialog>()(
      context: context,
      movements: context.read<ProductController>().movements,
      shedId: shedId,
      shedName: shedName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final productController = context.watch<ProductController>();
    final controller = context.watch<ShedController>();
    final products = productController.products;
    final sheds = controller.sheds;
    final citySearch = citySearchController.text.trim().toLowerCase();
    final filteredSheds = sheds.where((shed) {
      final matchesCity =
          citySearch.isEmpty || shed.locate.toLowerCase().contains(citySearch);
      final usedCapacity = productController.stockForShed(shed.id);
      final hasAvailableStock = usedCapacity < shed.maxCapacity;
      final hasLowStock = products.any((product) {
        final stock = productController.stockForProductInShed(
          product.id,
          shed.id,
        );
        return stock > 0 && stock <= lowStockLimit;
      });
      final matchesAvailability =
          availabilityFilter == 'all' ||
          availabilityFilter == 'available' && hasAvailableStock ||
          availabilityFilter == 'unavailable' && !hasAvailableStock ||
          availabilityFilter == 'low_stock' && hasLowStock;

      return matchesCity && matchesAvailability;
    }).toList();
    final isDarkTheme =
        context.watch<ThemeController>().themeMode == ThemeMode.dark;
    final isMobile = context.isMobile;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorfulPageHeader(
            title: l10n.shedsTitle,
            icon: Icons.warehouse_outlined,
            isDarkTheme: isDarkTheme,
            mobileActionsBelowHeader: true,
            actions: sheds.isEmpty
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

                      final searchField = TextField(
                        controller: citySearchController,
                        decoration:
                            filterDecoration(l10n.searchByCity).copyWith(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: citySearch.isEmpty
                                  ? null
                                  : IconButton(
                                      onPressed: () {
                                        citySearchController.clear();
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.clear),
                                    ),
                            ),
                        onChanged: (_) => setState(() {}),
                      );
                      final availabilityField = DropdownButtonFormField<String>(
                        value: availabilityFilter,
                        isExpanded: true,
                        decoration: filterDecoration(l10n.availability),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(l10n.allSheds),
                          ),
                          DropdownMenuItem(
                            value: 'available',
                            child: Text(l10n.withAvailableStock),
                          ),
                          DropdownMenuItem(
                            value: 'unavailable',
                            child: Text(l10n.withoutAvailableStock),
                          ),
                          DropdownMenuItem(
                            value: 'low_stock',
                            child: Text(l10n.withLowStockProducts),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            availabilityFilter = value;
                          });
                        },
                      );

                      return Row(
                        children: [
                          Expanded(child: searchField),
                          const SizedBox(width: 8),
                          Expanded(child: availabilityField),
                        ],
                      );
                    },
                  ),
            mobileActions: sheds.isEmpty
                ? null
                : [
                    TextField(
                      controller: citySearchController,
                      decoration:
                          dialogInputDecoration(
                            context,
                            l10n.searchByCity,
                          ).copyWith(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: citySearch.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      citySearchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                          ),
                      onChanged: (_) => setState(() {}),
                    ),
                    DropdownButtonFormField<String>(
                      value: availabilityFilter,
                      isExpanded: true,
                      decoration:
                          dialogInputDecoration(
                            context,
                            l10n.availability,
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
                          child: Text(l10n.allSheds),
                        ),
                        DropdownMenuItem(
                          value: 'available',
                          child: Text(l10n.withAvailableStock),
                        ),
                        DropdownMenuItem(
                          value: 'unavailable',
                          child: Text(l10n.withoutAvailableStock),
                        ),
                        DropdownMenuItem(
                          value: 'low_stock',
                          child: Text(l10n.withLowStockProducts),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          availabilityFilter = value;
                        });
                      },
                    ),
                  ],
          ),
          if (controller.isLoading)
            const Expanded(child: Center(child: ProgressRing()))
          else if (sheds.isEmpty)
            Center(child: Text(l10n.noShed))
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: filteredSheds.isEmpty
                        ? Center(child: Text(l10n.noShedForFilters))
                        : ListView.builder(
                            itemCount: filteredSheds.length,
                            itemBuilder: (context, index) {
                              final shed = filteredSheds[index];
                              final shedProducts = products
                                  .where(
                                    (product) =>
                                        productController.stockForProductInShed(
                                          product.id,
                                          shed.id,) > 0,
                                  )
                                  .toList();
                              final usedCapacity = productController
                                  .stockForShed(shed.id);
                              final isExpanded = expandedShedId == shed.id;
                              final capacityPills = [
                                _ShedInfoPill(
                                  label: l10n.capacityValue(
                                    shed.maxCapacity.toString(),
                                  ),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .tertiary
                                      .withOpacity(0.18),
                                  textColor: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  isMobile: isMobile,
                                ),
                                _ShedInfoPill(
                                  label: l10n.usedCapacityValue(
                                    usedCapacity.toString(),
                                  ),
                                  color: Colors.lightBlue.shade100,
                                  textColor: Colors.black87,
                                  isMobile: isMobile,
                                ),
                              ];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                  vertical: isMobile ? 1 : 4,
                                  horizontal: isMobile ? 4 : 10,
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      minLeadingWidth: isMobile ? 28 : 36,
                                      horizontalTitleGap: isMobile ? 8 : 12,
                                      minVerticalPadding: isMobile ? 4 : 6,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: isMobile ? 8 : 12,
                                        vertical: isMobile ? 0 : 0,
                                      ),
                                      leading: CircleAvatar(
                                        radius: isMobile ? 16 : 18,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withOpacity(0.16),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          size: isMobile ? 17 : 21,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                      title: Text(
                                        shed.nome,
                                        maxLines: 1,
                                        overflow: responsiveTextOverflow(context),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      subtitle: isMobile
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  shed.locate,
                                                  maxLines: 1,
                                                  overflow:
                                                      responsiveTextOverflow(context),
                                                ),
                                                const SizedBox(height: 4),
                                                Wrap(
                                                  spacing: 3,
                                                  runSpacing: 3,
                                                  children: capacityPills,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              shed.locate,
                                              maxLines: 1,
                                              overflow: responsiveTextOverflow(context),
                                            ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (!isMobile) ...[
                                            ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                maxWidth: 260,
                                              ),
                                              child: Wrap(
                                                spacing: 6,
                                                runSpacing: 4,
                                                alignment: WrapAlignment.end,
                                                children: capacityPills,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                          ],
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints
                                                            .tightFor(
                                                      width: isMobile ? 30 : 36,
                                                      height: isMobile ? 28 : 32,
                                                    ),
                                                    onPressed: () =>
                                                        showMovimentations(
                                                      shedId: shed.id,
                                                      shedName: shed.nome,
                                                    ),
                                                    icon: Icon(
                                                      Icons.remove_red_eye,
                                                      size: isMobile ? 16 : 18,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints
                                                            .tightFor(
                                                      width: isMobile ? 30 : 36,
                                                      height: isMobile ? 28 : 32,
                                                    ),
                                                    onPressed: () async {
                                                      await context
                                                          .read<
                                                              EditShedDialog>()(
                                                        context: context,
                                                        shed: shed,
                                                        nameController:
                                                            nameController,
                                                        locateController:
                                                            locateController,
                                                        maxCapacityController:
                                                            maxCapacityController,
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      size: isMobile ? 16 : 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints
                                                            .tightFor(
                                                      width: isMobile ? 30 : 36,
                                                      height: isMobile ? 28 : 32,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        expandedShedId =
                                                            isExpanded
                                                                ? null
                                                                : shed.id;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      isExpanded
                                                          ? Icons.expand_less
                                                          : Icons.expand_more,
                                                      size: isMobile ? 16 : 18,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    padding: EdgeInsets.zero,
                                                    constraints:
                                                        BoxConstraints
                                                            .tightFor(
                                                      width: isMobile ? 30 : 36,
                                                      height: isMobile ? 28 : 32,
                                                    ),
                                                    onPressed: () async {
                                                      await context
                                                          .read<
                                                              ShedActionsDialog>()(
                                                        context: context,
                                                        shed: shed,
                                                        nameController:
                                                            nameController,
                                                        locateController:
                                                            locateController,
                                                        maxCapacityController:
                                                            maxCapacityController,
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        setState(() {
                                          expandedShedId = isExpanded
                                              ? null
                                              : shed.id;
                                        });
                                      },
                                      onLongPress: () async =>
                                          context.read<ShedActionsDialog>()(
                                            context: context,
                                            shed: shed,
                                            nameController: nameController,
                                            locateController: locateController,
                                            maxCapacityController:
                                                maxCapacityController,
                                          ),
                                    ),
                                    AnimatedCrossFade(
                                      firstChild: const SizedBox.shrink(),
                                      secondChild: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          isMobile ? 10 : 16,
                                          0,
                                          isMobile ? 8 : 16,
                                          isMobile ? 8 : 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Divider(height: 1),
                                            SizedBox(height: isMobile ? 8 : 12),
                                            Center(
                                              child: Text(l10n.productsInShed),
                                            ),
                                            SizedBox(height: isMobile ? 6 : 8),
                                            if (shedProducts.isEmpty)
                                              Text(
                                                l10n.noProductsInShed,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.64),
                                                ),
                                              )
                                            else
                                              ...shedProducts.map((product) {
                                                final productMovements =
                                                productController.movements
                                                .where((movement) =>
                                                movement.productId == product.id &&
                                                movement.shedId == shed.id,
                                                );
                                                final totalEntries =
                                                productMovements.fold<int>(0,
                                                (total, movement) =>
                                                total + movement.entryQuantity,
                                                );
                                                final totalExits =
                                                productMovements.fold<int>(0,
                                                (total, movement) => total +
                                                 movement.exitQuantity,
                                                 );
                                                final currentQuantity =
                                                productController
                                                .stockForProductInShed(
                                                product.id,
                                                shed.id,
                                                );
                                                final isLowStock =
                                                currentQuantity > 0 &&
                                                currentQuantity <= lowStockLimit;
                                                final categoryLine =
                                                product.subcategoryName.trim()
                                                .isEmpty
                                                ? product.categoryName
                                                : '${product.categoryName} - ${product.subcategoryName}';
                                                return Card(
                                                  margin:
                                                  EdgeInsets.symmetric(
                                                  vertical: isMobile ? 3 : 6,
                                                  ),
                                                  child: ExpansionTile(
                                                    tilePadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          isMobile ? 10 : 16,
                                                    ),
                                                    leading: ProductImagePreview(
                                                      imageUrl: product.image,
                                                    ),
                                                    title: Text(
                                                      product.nome,
                                                      maxLines: 1,
                                                      overflow:
                                                          responsiveTextOverflow(context),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      '${l10n.sku}: ${product.sku}\n'
                                                      '$categoryLine',
                                                      maxLines: 2,
                                                      overflow:
                                                          responsiveTextOverflow(context),
                                                    ),
                                                    trailing: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal:
                                                                isMobile ? 8 : 12,
                                                            vertical:
                                                                isMobile ? 4 : 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary
                                                            .withOpacity(0.18),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Text(
                                                        'R\$ ${product.price.toStringAsFixed(2)}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                    ),
                                                    childrenPadding:
                                                        EdgeInsets.fromLTRB(
                                                          isMobile ? 10 : 16,
                                                          0,
                                                          isMobile ? 8 : 16,
                                                          isMobile ? 8 : 16,
                                                        ),
                                                    children: [
                                                      LayoutBuilder(
                                                        builder: (context, constraints) {
                                                          final chipWidth =
                                                          constraints.maxWidth >=
                                                          560
                                                          ? (constraints.maxWidth -
                                                          16) / 3
                                                          : constraints.maxWidth;
                                                          return Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    chipWidth,
                                                                child: _ShedProductQuantityChip(
                                                                  label: l10n
                                                                      .currentQuantity,
                                                                  value:
                                                                      currentQuantity,
                                                                  color:
                                                                      isLowStock
                                                                      ? Colors
                                                                            .red
                                                                      : Theme.of(
                                                                          context,
                                                                        ).colorScheme.primary,
                                                                  icon: Icons
                                                                      .inventory_2_outlined,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    chipWidth,
                                                                child: _ShedProductQuantityChip(
                                                                  label: l10n
                                                                      .entryQuantity,
                                                                  value:
                                                                      totalEntries,
                                                                  color: Colors
                                                                      .green,
                                                                  icon: Icons
                                                                      .arrow_downward,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    chipWidth,
                                                                child: _ShedProductQuantityChip(
                                                                  label: l10n
                                                                      .exitQuantity,
                                                                  value:
                                                                      totalExits,
                                                                  color: Colors
                                                                      .red,
                                                                  icon: Icons
                                                                      .arrow_upward,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                          ],
                                        ),
                                      ),
                                      crossFadeState: isExpanded
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 12,
              vertical: isMobile ? 4 : 8,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  _clearShedForm();
                  await context.read<CreateShedDialog>()(
                    context: context,
                    nameController: nameController,
                    locateController: locateController,
                    maxCapacityController: maxCapacityController,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_location),
                    const SizedBox(width: 8),
                    Text(l10n.addShed),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 6 : 25),
        ],
      ),
    );
  }
}

class _ShedInfoPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final bool isMobile;

  const _ShedInfoPill({
    required this.label,
    required this.color,
    required this.textColor,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? 122 : 160,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 10,
        vertical: isMobile ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: TextStyle(
          color: textColor,
          fontSize: isMobile ? 10 : 12,
          height: 1.05,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ShedProductQuantityChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;

  const _ShedProductQuantityChip({
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
