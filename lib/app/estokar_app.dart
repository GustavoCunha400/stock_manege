import 'package:estokar_gestaodeestoque/core/theme/app_theme.dart';
import 'package:fluent_ui/fluent_ui.dart' hide ThemeMode;
import 'package:flutter/material.dart' as material;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme/controllers/theme_controller.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/locale/locale_controller.dart';

class EstokarApp extends StatelessWidget {
  const EstokarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleController>().locale;
    final themeMode = context.watch<ThemeController>().themeMode;
    final router = context.watch<GoRouter>();

    return FluentApp.router(
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        final platformBrightness = material.MediaQuery.platformBrightnessOf(
          context,
        );
        final useDarkTheme =
            themeMode == material.ThemeMode.dark ||
            (themeMode == material.ThemeMode.system &&
                platformBrightness == material.Brightness.dark);

        return material.Theme(
          data: useDarkTheme
              ? AppTheme.materialDarkTheme
              : AppTheme.materialLightTheme,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

