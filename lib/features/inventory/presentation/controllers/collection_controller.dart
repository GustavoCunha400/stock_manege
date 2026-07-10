import 'package:flutter/foundation.dart';

/// Base para controladores que exibem uma colecao carregada de forma assincrona.
///
/// Centraliza apenas o estado de apresentacao compartilhado. As regras de negocio
/// continuam nos casos de uso de cada recurso.
abstract class CollectionController<T> extends ChangeNotifier {
  List<T> _items = const [];
  bool _isLoading = false;

  List<T> get items => _items;
  bool get isLoading => _isLoading;

  Future<List<T>> fetchItems();

  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await fetchItems();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
