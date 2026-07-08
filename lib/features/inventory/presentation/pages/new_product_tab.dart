import 'package:fluent_ui/fluent_ui.dart' show ProgressRing;
import 'package:estokar_gestaodeestoque/app/app_breakpoints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/utils/price_input_formatter.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/category_controller.dart';
import '../controllers/new_product_form_controller.dart';

class NewProductForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController descriptionController;
  final TextEditingController imageController;
  final TextEditingController priceController;
  final VoidCallback onCancel;
  final VoidCallback onCreate;

  const NewProductForm({
    super.key,
    required this.nameController,
    required this.skuController,
    required this.descriptionController,
    required this.imageController,
    required this.priceController,
    required this.onCancel,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = context.isMobile;

    return Expanded(
      child: Consumer<NewProductFormController>(
        builder: (context, formController, child) {
          final categories = context.watch<CategoryController>().categories;
          final selectedCategory = categories
              .where(
                (category) => category.id == formController.selectedCategoryId,
              )
              .firstOrNull;
          final subcategories = selectedCategory?.subcategories ?? [];

          if (formController.isLoadingOptions) {
            return const Center(child: ProgressRing());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 6 : 12),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: dialogInputDecoration(context, l10n.name),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: skuController,
                  decoration: dialogInputDecoration(context, l10n.sku),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: descriptionController,
                  decoration: dialogInputDecoration(context, l10n.description),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: imageController,
                  decoration: dialogInputDecoration(context, l10n.imageUrl),
                ),
                const SizedBox(height: 6),
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
                const SizedBox(height: 6),
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
                  onChanged:
                      categories.isEmpty ? null : formController.selectCategory,
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: formController.selectedSubcategoryName,
                  decoration: dialogInputDecoration(context, l10n.subcategory),
                  items: subcategories
                      .map(
                        (subcategory) => DropdownMenuItem(
                          value: subcategory.name,
                          child: Text(subcategory.name),
                        ),
                      )
                      .toList(),
                  onChanged: selectedCategory == null || subcategories.isEmpty
                      ? null
                      : formController.selectSubcategory,
                ),
                const SizedBox(height: 6),
                if (categories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(l10n.missingProductDependencies),
                  ),
                SizedBox(height: isMobile ? 10 : 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        child: Text(l10n.cancel),
                      ),
                    ),
                    SizedBox(width: isMobile ? 8 : 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCreate,
                        child: Text(l10n.create),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
