import 'package:flutter/foundation.dart';

import '../../domain/entities/product.dart';

class StockMovementFormController extends ChangeNotifier {
  String? _selectedProductId;
  String? _selectedShedId;
  DateTime _selectedDate = DateTime.now();

  String? get selectedProductId => _selectedProductId;

  String? get selectedShedId => _selectedShedId;

  DateTime get selectedDate => _selectedDate;

  void start(List<Product> products, {String? initialShedId}) {
    _selectedProductId = products.isEmpty ? null : products.first.id;
    _selectedShedId = initialShedId;
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    notifyListeners();
  }

  void selectProduct(String? productId) {
    if (_selectedProductId == productId) return;

    _selectedProductId = productId;
    notifyListeners();
  }

  void selectShed(String? shedId) {
    if (_selectedShedId == shedId) return;

    _selectedShedId = shedId;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    final cleanDate = DateTime(date.year, date.month, date.day);
    if (_selectedDate == cleanDate) return;

    _selectedDate = cleanDate;
    notifyListeners();
  }
}

