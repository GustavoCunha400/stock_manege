import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String message, {
  String? title,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final l10n = AppLocalizations.of(dialogContext)!;

      return AlertDialog(
        title: Text(title ?? l10n.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.ok),
          ),
        ],
      );
    },
  );
}

