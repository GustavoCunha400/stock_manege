import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/utils/price_input_formatter.dart';
import '../../../../core/utils/show_error_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/product.dart';
import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';

class EditItem {
  Future<void> call({
    required BuildContext context,
    required Product item,
    required bool Function() isMounted,
  }) async {
    final productController = context.read<ProductController>();
    final categoryController = context.read<CategoryController>();

    if (categoryController.categories.isEmpty) {
      await categoryController.loadCategory();
    }
    final nameController = TextEditingController(text: item.nome);
    final skuController = TextEditingController(text: item.sku);
    final descriptionController = TextEditingController(text: item.description);
    final imageController = TextEditingController(text: item.image);
    final priceController = TextEditingController(
      text: item.price.toStringAsFixed(2),
    );

    String? selectedCategoryId = categoryController.categories
        .where((category) => category.name == item.categoryName)
        .firstOrNull
        ?.id;
    String? selectedSubcategoryName = item.subcategoryName;
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              final categories = categoryController.categories;
              final selectedCategory = categories
                  .where((category) => category.id == selectedCategoryId)
                  .firstOrNull;
              final subcategories = selectedCategory?.subcategories ?? [];
              if (!subcategories.any(
                (subcategory) => subcategory.name == selectedSubcategoryName,
              )) {
                selectedSubcategoryName = null;
              }
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.edit),
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
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.name,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: skuController,
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.sku,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.description,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: imageController,
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.imageUrl,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: priceController,
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.price,
                          prefixText: 'R\$ ',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [PriceInputFormatter()],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.category,
                        ),
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
                            : (value) {
                                setDialogState(() {
                                  selectedCategoryId = value;
                                  selectedSubcategoryName = null;
                                });
                              },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedSubcategoryName,
                        decoration: dialogInputDecoration(
                          context,
                          AppLocalizations.of(context)!.subcategory,
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
                            : (value) {
                                setDialogState(() {
                                  selectedSubcategoryName = value;
                                });
                              },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(AppLocalizations.of(context)!.cancel,
                      style: TextStyle(color: Colors.red),),
                  ),
                  TextButton(
                    onPressed: () async {
                      final price = double.tryParse(
                        priceController.text.replaceAll(',', '.'),
                      );
                      final category = categories
                          .where(
                            (category) => category.id == selectedCategoryId,
                          )
                          .firstOrNull;

                      if (nameController.text.trim().isEmpty ||
                          skuController.text.trim().isEmpty ||
                          descriptionController.text.trim().isEmpty ||
                          price == null ||
                          price <= 0 ||
                          category == null ||
                          selectedSubcategoryName == null) {
                        await showErrorDialog(
                          context,
                          AppLocalizations.of(context)!.invalidProductFields,
                        );
                        return;
                      }
                      await productController.editProduct(
                        product: item,
                        nome: nameController.text,
                        sku: skuController.text,
                        description: descriptionController.text,
                        image: imageController.text,
                        price: price,
                        categoryName: category.name,
                        subcategoryName: selectedSubcategoryName!,
                      );
                      if (!isMounted()) return;
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      nameController.dispose();
      skuController.dispose();
      descriptionController.dispose();
      imageController.dispose();
      priceController.dispose();
    }
  }
}


