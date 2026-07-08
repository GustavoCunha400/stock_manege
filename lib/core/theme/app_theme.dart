import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as material;

class AppTheme {
  static const material.Color lightBackground = material.Color(0xFFF2F7FF);
  static const material.Color lightSurface = material.Color(0xFFFFFFFF);
  static const material.Color lightPane = material.Color(0xFFE6F0FF);
  static const material.Color lightPrimary = material.Color(0xFF246BFE);
  static const material.Color lightSecondary = material.Color(0xFF00A889);
  static const material.Color lightAccent = material.Color(0xFFFFB020);

  static const material.Color darkBackground = material.Color(0xFF0D1321);
  static const material.Color darkSurface = material.Color(0xFF171E2F);
  static const material.Color darkPane = material.Color(0xFF111B2E);
  static const material.Color darkPrimary = material.Color(0xFF6EA8FF);
  static const material.Color darkSecondary = material.Color(0xFF4ED7B8);
  static const material.Color darkAccent = material.Color(0xFFFFC857);

  static const List<material.Color> lightGradient = [
    material.Color(0xFF246BFE),
    material.Color(0xFF00A889),
    material.Color(0xFFFFB020),
  ];

  static const List<material.Color> darkGradient = [
    material.Color(0xFF243B73),
    material.Color(0xFF0E8C7F),
    material.Color(0xFF9A6A16),
  ];

  static final fluent.FluentThemeData lightTheme =
      fluent.FluentThemeData.light().copyWith(
        brightness: material.Brightness.light,

        accentColor: fluent.Colors.blue,

        scaffoldBackgroundColor: lightBackground,

        cardColor: lightSurface,

        menuColor: lightSurface,

        selectionColor: lightPrimary.withOpacity(0.18),

        navigationPaneTheme: const fluent.NavigationPaneThemeData(
          backgroundColor: lightPane,
        ),
      );

  static final fluent.FluentThemeData darkTheme = fluent.FluentThemeData.dark()
      .copyWith(
        brightness: material.Brightness.dark,

        accentColor: fluent.Colors.blue,

        scaffoldBackgroundColor: darkBackground,

        cardColor: darkSurface,

        menuColor: darkSurface,

        selectionColor: darkSecondary.withOpacity(0.28),

        navigationPaneTheme: const fluent.NavigationPaneThemeData(
          backgroundColor: darkPane,
        ),
      );

  static final material.ThemeData materialLightTheme = material.ThemeData(
    useMaterial3: true,
    brightness: material.Brightness.light,
    colorScheme: material.ColorScheme.fromSeed(
      seedColor: lightPrimary,
      brightness: material.Brightness.light,
      primary: lightPrimary,
      secondary: lightSecondary,
      tertiary: lightAccent,
      surface: lightSurface,
    ),
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightSurface,
    appBarTheme: const material.AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: material.Color(0xFF10213F),
      elevation: 0,
    ),
    drawerTheme: const material.DrawerThemeData(backgroundColor: lightPane),
    cardTheme: material.CardThemeData(
      color: lightSurface,
      elevation: 3,
      shadowColor: lightPrimary.withOpacity(0.16),
      surfaceTintColor: lightSecondary.withOpacity(0.08),
      margin: material.EdgeInsets.zero,
      shape: material.RoundedRectangleBorder(
        borderRadius: material.BorderRadius.circular(18),
      ),
    ),
    elevatedButtonTheme: material.ElevatedButtonThemeData(
      style: material.ElevatedButton.styleFrom(
        backgroundColor: lightPrimary,
        foregroundColor: material.Colors.white,
        elevation: 3,
        shadowColor: lightPrimary.withOpacity(0.35),
        padding: const material.EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: material.RoundedRectangleBorder(
          borderRadius: material.BorderRadius.circular(14),
        ),
        textStyle: const material.TextStyle(
          fontWeight: material.FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    inputDecorationTheme: material.InputDecorationTheme(
      filled: true,
      fillColor: material.Colors.white,
      border: material.InputBorder.none,
      enabledBorder: material.InputBorder.none,
      focusedBorder: material.InputBorder.none,
    ),
  );

  static final material.ThemeData materialDarkTheme = material.ThemeData(
    useMaterial3: true,
    brightness: material.Brightness.dark,
    colorScheme: material.ColorScheme.fromSeed(
      seedColor: darkPrimary,
      brightness: material.Brightness.dark,
      primary: darkPrimary,
      secondary: darkSecondary,
      tertiary: darkAccent,
      surface: darkSurface,
    ),
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkSurface,
    appBarTheme: const material.AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: material.Color(0xFFF3F7FF),
      elevation: 0,
    ),
    drawerTheme: const material.DrawerThemeData(backgroundColor: darkPane),
    cardTheme: material.CardThemeData(
      color: darkSurface,
      elevation: 3,
      shadowColor: material.Colors.black.withOpacity(0.32),
      surfaceTintColor: darkSecondary.withOpacity(0.08),
      margin: material.EdgeInsets.zero,
      shape: material.RoundedRectangleBorder(
        borderRadius: material.BorderRadius.circular(18),
      ),
    ),
    elevatedButtonTheme: material.ElevatedButtonThemeData(
      style: material.ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: const material.Color(0xFF08111F),
        elevation: 3,
        shadowColor: darkPrimary.withOpacity(0.32),
        padding: const material.EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        shape: material.RoundedRectangleBorder(
          borderRadius: material.BorderRadius.circular(14),
        ),
        textStyle: const material.TextStyle(
          fontWeight: material.FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    inputDecorationTheme: material.InputDecorationTheme(
      filled: true,
      fillColor: const material.Color(0xFF10182A),
      border: material.InputBorder.none,
      enabledBorder: material.InputBorder.none,
      focusedBorder: material.InputBorder.none,
    ),
  );
}

