import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/shed_stock.dart';
import '../controllers/shed_controller.dart';

class ShedActionsDialog {
  Future<void> call({
    required BuildContext context,
    required ShedStock shed,
    required TextEditingController nameController,
    required TextEditingController locateController,
    required TextEditingController maxCapacityController,
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
              await context.read<ShedController>().deleteShed(shed.id);
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


