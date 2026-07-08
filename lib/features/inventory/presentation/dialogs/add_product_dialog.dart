import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/utils/price_input_formatter.dart';
import '../../../../core/utils/show_error_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/category_controller.dart';
import '../controllers/new_product_form_controller.dart';
import '../controllers/product_controller.dart';

class AddProductDialog {
  Future<void> call({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController skuController,
    required TextEditingController descriptionController,
    required TextEditingController imageController,
    required TextEditingController priceController,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final productController = context.read<ProductController>();
    final categoryController = context.read<CategoryController>();

    void clearForm() {
      context.read<NewProductFormController>().reset();
      nameController.clear();
      skuController.clear();
      descriptionController.clear();
      imageController.clear();
      priceController.clear();
    }

    clearForm();

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
        return Consumer<NewProductFormController>(
          builder: (context, formController, child) {
            final categories = categoryController.categories;
            final selectedCategory = categories
                .where(
                  (category) =>
                      category.id == formController.selectedCategoryId,
                )
                .firstOrNull;
            final subcategories = selectedCategory?.subcategories ?? [];

            return AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: Navigator.of(dialogContext).pop,
                    icon: const Icon(Icons.close,size: 18,),
                  ),
                  Row(
                    children: [
                      Text(l10n.createNewProduct),
                    ],
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: dialogInputDecoration(context, l10n.name),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: skuController,
                      decoration: dialogInputDecoration(context, l10n.sku),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration: dialogInputDecoration(
                        context,
                        l10n.description,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: imageController,
                      decoration: dialogInputDecoration(context, l10n.imageUrl),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      decoration: dialogInputDecoration(
                        context,
                        l10n.price,
                        prefixText: 'R\$ ',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [PriceInputFormatter()],
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: formController.selectedCategoryId,
                      decoration: dialogInputDecoration(context, l10n.category),
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ),
                          )
                          .toList(),
                      onChanged: categories.isEmpty
                          ? null
                          : formController.selectCategory,
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: formController.selectedSubcategoryName,
                      decoration: dialogInputDecoration(
                        context,
                        l10n.subcategory,
                      ),
                      items: subcategories
                          .map(
                            (subcategory) => DropdownMenuItem(
                              value: subcategory.name,
                              child: Text(subcategory.name),
                            ),
                          )
                          .toList(),
                      onChanged:
                          selectedCategory == null || subcategories.isEmpty
                          ? null
                          : formController.selectSubcategory,
                    ),
                    SizedBox(height: 8),
                    if (categories.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(l10n.missingProductDependencies),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final price = double.tryParse(
                      priceController.text.replaceAll(',', '.'),
                    );
                    final category = categories
                        .where(
                          (category) =>
                              category.id == formController.selectedCategoryId,
                        )
                        .firstOrNull;

                    if (nameController.text.trim().isEmpty ||
                        skuController.text.trim().isEmpty ||
                        descriptionController.text.trim().isEmpty ||
                        price == null ||
                        category == null) {
                      await showErrorDialog(context, l10n.invalidProductFields);
                      return;
                    }

                    await productController.createProduct(
                      nome: nameController.text,
                      sku: skuController.text,
                      description: descriptionController.text,
                      image: imageController.text,
                      price: price,
                      categoryName: category.name,
                      subcategoryName:
                          formController.selectedSubcategoryName ?? '',
                    );

                    clearForm();
                    if (!context.mounted) return;
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.create),
                ),
              ],
            );
          },
        );
        },
      );
    } finally {
      clearForm();
    }
  }
}


