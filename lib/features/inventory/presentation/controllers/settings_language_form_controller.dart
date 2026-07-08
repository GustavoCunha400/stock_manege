import 'package:flutter/material.dart';

class SettingsLanguageFormController extends ChangeNotifier {
  Locale _selectedLocale = const Locale('pt');

  Locale get selectedLocale => _selectedLocale;

  void start(Locale locale) {
    _selectedLocale = locale;
    notifyListeners();
  }

  void selectLocale(Locale locale) {
    if (_selectedLocale == locale) return;

    _selectedLocale = locale;
    notifyListeners();
  }
}

