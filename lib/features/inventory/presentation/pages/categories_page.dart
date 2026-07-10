import 'package:fluent_ui/fluent_ui.dart' show ProgressRing;
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:estokar_gestaodeestoque/core/theme/controllers/theme_controller.dart';
import 'package:estokar_gestaodeestoque/core/utils/colorful_page_header.dart';
import 'package:estokar_gestaodeestoque/core/utils/dialog_input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../../presentation/dialogs/category_actions_dialog.dart';
import '../../presentation/dialogs/create_category_dialog.dart';
import '../../presentation/dialogs/edit_category_dialog.dart';
import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/card_action_buttons.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subcategoryController = TextEditingController();
  final TextEditingController productSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CategoryController>().loadCategory();
        context.read<ProductController>().loadProducts();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    subcategoryController.dispose();
    productSearchController.dispose();
    super.dispose();
  }

  void _clearCategoryForm() {
    nameController.clear();
    descriptionController.clear();
    subcategoryController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = context.watch<CategoryController>();
    final products = context.watch<ProductController>().products;
    final categories = controller.categories;
    final productSearch = productSearchController.text.trim().toLowerCase();
    final filteredCategories = productSearch.isEmpty
        ? categories
        : categories.where((category) {
            return products.any((product) {
              final isFromCategory = product.categoryName == category.name;
              final isFromSubcategory = (category.subcategories ?? []).any(
                (subcategory) =>
                    product.subcategoryName == subcategory.name &&
                    product.categoryName == category.name,
              );

              if (!isFromCategory && !isFromSubcategory) return false;

              return product.nome.toLowerCase().contains(productSearch) ||
                  product.sku.toLowerCase().contains(productSearch) ||
                  product.description.toLowerCase().contains(productSearch);
            });
          }).toList();
    final isDarkTheme =
        context.watch<ThemeController>().themeMode == ThemeMode.dark;
    final isMobile = context.isMobile;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorfulPageHeader(
            title: l10n.categories,
            icon: Icons.category_outlined,
            isDarkTheme: isDarkTheme,
            mobileActionsBelowHeader: true,
            actions: categories.isEmpty
                ? null
                : Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: double.infinity,
                      child: TextField(
                        controller: productSearchController,
                        decoration: dialogInputDecoration(
                          context,
                          l10n.searchProductByCategory,
                        ).copyWith(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: productSearch.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    productSearchController.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.clear),
                                ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
            mobileActions: categories.isEmpty
                ? null
                : [
                    TextField(
                      controller: productSearchController,
                      decoration:
                          dialogInputDecoration(
                            context,
                            l10n.searchProductByCategory,
                          ).copyWith(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: productSearch.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      productSearchController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                          ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
          ),
          if (controller.isLoading)
            const Expanded(child: Center(child: ProgressRing()))
          else if (categories.isEmpty)
            Center(child: Text(l10n.noCategory))
          else
            Expanded(
              child: filteredCategories.isEmpty
                  ? Center(
                      child: Text(
                        l10n.noCategoryFoundForProduct,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCategories.length,
                      itemBuilder: (context, index) => _CategoryCard(
                        category: filteredCategories[index],
                        nameController: nameController,
                        descriptionController: descriptionController,
                        subcategoryController: subcategoryController,
                      ),
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
                  _clearCategoryForm();
                  await context.read<CreateCategoryDialog>()(
                    context: context,
                    nameController: nameController,
                    descriptionController: descriptionController,
                    subcategoryController: subcategoryController,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_circle),
                    const SizedBox(width: 8),
                    Text(l10n.addCategory),
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

class _CategoryCard extends StatefulWidget {
  const _CategoryCard({
    required this.category,
    required this.nameController,
    required this.descriptionController,
    required this.subcategoryController,
  });

  final Category category;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController subcategoryController;

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isMobile;
    final category = widget.category;
    final subcategories = category.subcategories ?? [];
    final hasSubcategories = subcategories.isNotEmpty;
    final leading = CircleAvatar(
      radius: isMobile ? 17 : 20,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.14),
      child: Icon(
        Icons.sell_outlined,
        size: isMobile ? 18 : 24,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    final title = Text(
      category.name,
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
    final subtitle = Text(
      subcategories.isEmpty
          ? '${l10n.description}: ${category.description}'
          : '${l10n.description}: ${category.description} \n'
          '${l10n.subcategory}: ${subcategories.length}',
    );

    Future<void> showDeleteConfirmation() async {
      context.read<CategoryActionsDialog>()(
        context: context,
        category: category,
        nameController: widget.nameController,
        descriptionController: widget.descriptionController,
        subcategoryController: widget.subcategoryController,
      );
    }

    Future<void> showEditDialog() async {
      await context.read<EditCategoryDialog>()(
        context: context,
        category: category,
        nameController: widget.nameController,
        descriptionController: widget.descriptionController,
        subcategoryController: widget.subcategoryController,
      );
    }

    return GestureDetector(
      onLongPress: showDeleteConfirmation,
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: isMobile ? 2 : 6,
          horizontal: isMobile ? 4 : 12,
        ),
        child: Column(
          children: [
            ListTile(
                dense: isMobile,
                minLeadingWidth: isMobile ? 34 : null,
                horizontalTitleGap: isMobile ? 8 : 16,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 16,
                  vertical: isMobile ? 0 : 2,
                ),
                leading: leading,
                title: title,
                subtitle: subtitle,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasSubcategories)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: isMobile ? 18 : 22,
                        ),
                      ),
                    CardActionButtons(
                      onEdit: showEditDialog,
                      onDelete: showDeleteConfirmation,
                    ),
                  ],
                ),
                onTap: hasSubcategories
                    ? () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      }
                    : null,
              ),
            if (hasSubcategories)
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: subcategories
                      .map(
                        (subcategory) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.subdirectory_arrow_right),
                          title: Text(subcategory.name),
                        ),
                      )
                      .toList(),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 180),
              ),
          ],
        ),
      ),
    );
  }
}
