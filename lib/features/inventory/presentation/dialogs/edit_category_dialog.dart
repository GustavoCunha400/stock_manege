import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/utils/show_error_dialog.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_controller.dart';

class EditCategoryDialog {
  Future<void> call({
    required BuildContext context,
    required Category category,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController subcategoryController,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final subcategories = category.subcategories ?? [];
    final subcategoryNames = subcategories
        .map((subcategory) => subcategory.name)
        .where((subcategory) => subcategory.trim().isNotEmpty)
        .toList();

    void clearForm() {
      nameController.clear();
      descriptionController.clear();
      subcategoryController.clear();
    }

    nameController.text = category.name;
    descriptionController.text = category.description;
    subcategoryController.clear();

    void addSubcategory(StateSetter setDialogState, String value) {
      final subcategoryName = value.trim();
      if (subcategoryName.isEmpty) return;

      setDialogState(() {
        subcategoryNames.add(subcategoryName);
        subcategoryController.clear();
      });
    }

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: Navigator.of(dialogContext).pop,
                icon: const Icon(Icons.close, size: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(l10n.edit),
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
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: dialogInputDecoration(context, l10n.description),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: subcategoryController,
                  decoration: dialogInputDecoration(
                    context,
                    l10n.subcategory,
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    addSubcategory(setDialogState, value);
                  },
                ),
                if (subcategoryNames.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: subcategoryNames
                          .map(
                            (subcategoryName) => InputChip(
                              label: Text(subcategoryName),
                              onDeleted: () {
                                setDialogState(() {
                                  subcategoryNames.remove(subcategoryName);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {
                  await showErrorDialog(
                    context,
                    'Informe nome e descricao da categoria.',
                  );
                  return;
                }

                final pendingSubcategories = subcategoryController.text
                    .split(',')
                    .map((subcategory) => subcategory.trim())
                    .where((subcategory) => subcategory.isNotEmpty);
                final allSubcategories = [
                  ...subcategoryNames,
                  ...pendingSubcategories,
                ];

                await context.read<CategoryController>().editCategory(
                  category: category,
                  nome: nameController.text,
                  description: descriptionController.text,
                  subcategories: allSubcategories,
                );

                clearForm();

                if (!context.mounted) return;
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        ),
        ),
      );
    } finally {
      clearForm();
    }
  }
}


