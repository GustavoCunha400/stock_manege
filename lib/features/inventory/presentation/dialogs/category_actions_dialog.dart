import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/category.dart';
import '../controllers/category_controller.dart';

class CategoryActionsDialog {
  Future<void> call({
    required BuildContext context,
    required Category category,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController subcategoryController,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
                Text(l10n.deleteCategoryQuestion, style: TextStyle(fontSize: 18),),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () async {
              await context.read<CategoryController>().deleteCategory(
                category.id,
              );

              if (!context.mounted) return;
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              l10n.remove,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}


