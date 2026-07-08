import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/product.dart';
import '../controllers/product_controller.dart';

class StockItemActionsDialog {
  Future<void> call({
    required BuildContext context,
    required Product item,
    required bool Function() isMounted,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(l10n.deleteItemQuestion),
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
              await context.read<ProductController>().deleteProduct(item.id);

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


