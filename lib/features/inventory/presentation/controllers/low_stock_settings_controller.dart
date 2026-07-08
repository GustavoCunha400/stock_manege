import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LowStockSettingsController extends ChangeNotifier {
  static const int defaultLimit = 5;
  static const String _limitKey = 'low_stock_limit';

  int _limit = defaultLimit;

  int get limit => _limit;

  Future<void> loadLowStockLimit() async {
    final preferences = await SharedPreferences.getInstance();
    final savedLimit = preferences.getInt(_limitKey);
    if (savedLimit == null || savedLimit < 1) return;

    _limit = savedLimit;
    notifyListeners();
  }

  Future<void> setLimit(int limit) async {
    if (limit < 1 || limit == _limit) return;

    _limit = limit;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_limitKey, limit);
  }
}
