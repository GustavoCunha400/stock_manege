import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/dialog_input_decoration.dart';
import '../../../../core/theme/controllers/theme_controller.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../l10n/locale/locale_controller.dart';
import '../controllers/settings_language_form_controller.dart';

class SettingsLanguageDialog {
  Future<void> call({required BuildContext context}) async {
    final localeController = context.read<LocaleController>();
    final themeController = context.read<ThemeController>();
    context.read<SettingsLanguageFormController>().start(
      localeController.locale,
    );
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Consumer<SettingsLanguageFormController>(
          builder: (context, languageFormController, child) {
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
              content: DropdownButtonFormField<Locale>(
                value: languageFormController.selectedLocale,
                decoration: dialogInputDecoration(context, l10n.language),
                items: [
                  DropdownMenuItem(
                    value: const Locale('pt'),
                    child: Text(l10n.languagePortuguese),
                  ),
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(l10n.languageEnglish),
                  ),
                  DropdownMenuItem(
                    value: const Locale('es'),
                    child: Text(l10n.languageSpanish),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    languageFormController.selectLocale(value);
                  }
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(l10n.cancel,style: TextStyle(color: Colors.red),),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    localeController.setLocale(
                      languageFormController.selectedLocale,
                    );
                  },
                  child: Text(l10n.save),
                ),
                Consumer<ThemeController>(
                  builder: (context, controller, child) {
                    final isLightTheme = controller.themeMode == ThemeMode.dark;

                    return SwitchListTile(
                      title: Text(l10n.darkTheme),
                      subtitle: Text(
                        isLightTheme ? l10n.active : l10n.lightThemeActive,
                      ),
                      value: isLightTheme,
                      onChanged: (value) {
                        themeController.setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}


