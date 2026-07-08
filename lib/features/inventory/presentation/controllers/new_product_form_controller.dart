import 'package:flutter/foundation.dart';

class NewProductFormController extends ChangeNotifier {
  String? _selectedCategoryId;
  String? _selectedSubcategoryName;
  String? _selectedShedId;
  bool _isLoadingOptions = false;

  String? get selectedCategoryId => _selectedCategoryId;

  String? get selectedSubcategoryName => _selectedSubcategoryName;

  String? get selectedShedId => _selectedShedId;

  bool get isLoadingOptions => _isLoadingOptions;

  void reset() {
    _selectedCategoryId = null;
    _selectedSubcategoryName = null;
    _selectedShedId = null;
    _isLoadingOptions = false;
    notifyListeners();
  }

  void setLoadingOptions(bool value) {
    if (_isLoadingOptions == value) return;

    _isLoadingOptions = value;
    notifyListeners();
  }

  void selectCategory(String? categoryId) {
    if (_selectedCategoryId == categoryId && _selectedSubcategoryName == null) {
      return;
    }

    _selectedCategoryId = categoryId;
    _selectedSubcategoryName = null;
    notifyListeners();
  }

  void selectSubcategory(String? subcategoryName) {
    if (_selectedSubcategoryName == subcategoryName) return;

    _selectedSubcategoryName = subcategoryName;
    notifyListeners();
  }

  void selectShed(String? shedId) {
    if (_selectedShedId == shedId) return;

    _selectedShedId = shedId;
    notifyListeners();
  }
}

