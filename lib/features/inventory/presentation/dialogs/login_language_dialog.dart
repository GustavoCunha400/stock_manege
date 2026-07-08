import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/locale/locale_controller.dart';

class LoginLanguageDialog {
  Future<void> call({required BuildContext context}) async {
    final l10n = AppLocalizations.of(context)!;
    final localeController = context.read<LocaleController>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
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
                  Text(l10n.selectLanguage),
                ],
              ),
            ],
          ),
          content: Consumer<LocaleController>(
            builder: (context, controller, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.languagePortuguese),
                    value: 'pt',
                    groupValue: controller.locale.languageCode,
                    onChanged: (value) {
                      localeController.setLocale(Locale(value!));
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.languageEnglish),
                    value: 'en',
                    groupValue: controller.locale.languageCode,
                    onChanged: (value) {
                      localeController.setLocale(Locale(value!));
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.languageSpanish),
                    value: 'es',
                    groupValue: controller.locale.languageCode,
                    onChanged: (value) {
                      localeController.setLocale(Locale(value!));
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel,style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }
}


