import 'package:fluent_ui/fluent_ui.dart' show ProgressRing, FluentIcons;
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:estokar_gestaodeestoque/core/theme/controllers/theme_controller.dart';
import 'package:estokar_gestaodeestoque/core/utils/colorful_page_header.dart';
import 'package:estokar_gestaodeestoque/core/utils/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/card_action_buttons.dart';
import '../../domain/usecases/product_image_preview.dart';
import '../dialogs/edit_item.dart';
import '../controllers/category_controller.dart';
import '../controllers/new_product_form_controller.dart';
import '../controllers/product_controller.dart';
import '../dialogs/stock_item_actions_dialog.dart';
import 'new_product_tab.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadOptions();
      }
    });
  }

  Future<void> _loadOptions() async {
    final formController = context.read<NewProductFormController>();
    formController.setLoadingOptions(true);

    await Future.wait([
      context.read<ProductController>().loadProducts(),
      context.read<CategoryController>().loadCategory(),
    ]);

    if (mounted) {
      formController.setLoadingOptions(false);
    }
  }

  void _clearProductForm() {
    context.read<NewProductFormController>().reset();

    nameController.clear();
    skuController.clear();
    descriptionController.clear();
    imageController.clear();
    priceController.clear();
  }

  Future<void> _openCreateProductTab() async {
    final l10n = AppLocalizations.of(context)!;
    final categories = context.read<CategoryController>().categories;

    if (categories.isEmpty) {
      await showErrorDialog(context, l10n.missingProductDependencies);
      return;
    }

    _clearProductForm();

    setState(() {
      _selectedTabIndex = 1;
    });
  }

  Future<void> _createProduct() async {
    final l10n = AppLocalizations.of(context)!;
    final formController = context.read<NewProductFormController>();
    final productController = context.read<ProductController>();
    final categories = context.read<CategoryController>().categories;

    final result = await productController.createProductFromForm(
      name: nameController.text,
      sku: skuController.text,
      description: descriptionController.text,
      imageUrl: imageController.text,
      priceText: priceController.text,
      selectedCategoryId: formController.selectedCategoryId,
      selectedSubcategoryName: formController.selectedSubcategoryName,
      categories: categories,
      productNameRequiredMessage: l10n.productNameRequired,
      productSkuRequiredMessage: l10n.productSkuRequired,
      productDescriptionRequiredMessage: l10n.productDescriptionRequired,
      invalidImageUrlMessage: l10n.invalidImageUrl,
      invalidPriceMessage: l10n.invalidPrice,
      priceGreaterThanZeroMessage: l10n.priceGreaterThanZero,
      selectCategoryMessage: l10n.selectCategory,
      selectSubcategoryMessage: l10n.selectSubcategory,
    );

    if (!mounted) return;

    if (!result.isSuccess) {
      await showErrorDialog(context, result.errors.join('\n'));
      return;
    }

    if (!mounted) return;
    _clearProductForm();
    setState(() {
      _selectedTabIndex = 0;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    skuController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLoadingOptions = context
        .watch<NewProductFormController>()
        .isLoadingOptions;
    final productController = context.watch<ProductController>();
    final products = productController.products;
    final categories = context.watch<CategoryController>().categories;
    final canCreateProduct = categories.isNotEmpty;
    final isDarkTheme =
        context.watch<ThemeController>().themeMode == ThemeMode.dark;
    final isMobile = context.isMobile;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColorfulPageHeader(
            title: l10n.product,
            icon: FluentIcons.product,
            isDarkTheme: isDarkTheme,
            actions: Align(
              alignment: Alignment.center,
              child: _buildProductTabs(
                context: context,
                l10n: l10n,
                canCreateProduct: canCreateProduct,
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (_selectedTabIndex == 0)
                  _buildProductList(
                    context: context,
                    products: products,
                    isLoading: productController.isLoading || isLoadingOptions,
                    l10n: l10n,
                  )
                else
                  NewProductForm(
                    nameController: nameController,
                    skuController: skuController,
                    descriptionController: descriptionController,
                    imageController: imageController,
                    priceController: priceController,
                    onCancel: () {
                      _clearProductForm();
                      setState(() {
                        _selectedTabIndex = 0;
                      });
                    },
                    onCreate: _createProduct,
                  ),
                SizedBox(height: isMobile ? 6 : 25),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductTabs({
    required BuildContext context,
    required AppLocalizations l10n,
    required bool canCreateProduct,
  }) {
    return SegmentedButton<int>(
      segments: [
        ButtonSegment(
          value: 0,
          icon: const Icon(Icons.inventory_2_outlined),
          label: Text(l10n.product),
        ),
        ButtonSegment(
          value: 1,
          icon: const Icon(FluentIcons.add_notes),
          label: Text(l10n.createNewProduct),
          enabled: canCreateProduct,
        ),
      ],
      selected: {_selectedTabIndex},
      onSelectionChanged: (selection) async {
        if (selection.first == 1 && !canCreateProduct) {
          await showErrorDialog(context, l10n.missingProductDependencies);
          return;
        }

        if (selection.first == 1) {
          await _openCreateProductTab();
          return;
        }

        setState(() {
          _selectedTabIndex = selection.first;
        });
      },
    );
  }

  Widget _buildProductList({
    required BuildContext context,
    required List<Product> products,
    required bool isLoading,
    required AppLocalizations l10n,
  }) {
    if (isLoading) {
      return const Expanded(child: Center(child: ProgressRing()));
    }

    if (products.isEmpty) {
      return Expanded(child: Center(child: Text(l10n.noProduct)));
    }
    final isMobile = context.isMobile;

    return Expanded(
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final categoryLine = product.subcategoryName.trim().isEmpty
              ? product.categoryName
              : '${product.categoryName} - ${product.subcategoryName}';

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
              leading: ProductImagePreview(imageUrl: product.image),
              title: Text(
                product.nome,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${l10n.sku}: ${product.sku}\n'
                '$categoryLine',
              ),
              childrenPadding: EdgeInsets.fromLTRB(
                isMobile ? 8 : 16,
                0,
                isMobile ? 8 : 16,
                isMobile ? 8 : 16,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'R\$ ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.stock}: '
                        '${context.read<ProductController>().stockForProduct(product.id)}',
                      ),
                    ],
                  ),
                  CardActionButtons(
                    onEdit: () async {
                      await context.read<EditItem>()(
                        context: context,
                        item: product,
                        isMounted: () => mounted,
                      );
                    },
                    onDelete: () async {
                      await context.read<StockItemActionsDialog>()(
                        context: context,
                        item: product,
                        isMounted: () => mounted,
                      );
                    },
                  ),
                ],
              ),
              children: [
                _ProductDetails(
                  sku: product.sku,
                  description: product.description,
                  categoryName: product.categoryName,
                  subcategoryName: product.subcategoryName,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String sku;
  final String description;
  final String categoryName;
  final String subcategoryName;

  const _ProductDetails({
    required this.sku,
    required this.description,
    required this.categoryName,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isMobile;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductDetailRow(label: l10n.sku, value: sku),
          _ProductDetailRow(label: l10n.description, value: description),
          _ProductDetailRow(label: l10n.category, value: categoryName),
          _ProductDetailRow(
            label: l10n.subcategory,
            value: subcategoryName,
          ),
        ],
      ),
    );
  }
}

class _ProductDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProductDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.isMobile ? 86 : 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontSize:13.5, fontWeight:FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value.trim().isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}
