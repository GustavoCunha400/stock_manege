import 'package:fluent_ui/fluent_ui.dart';

class AuthLoginController extends ChangeNotifier {
  bool _isLoggedIn = false;

  String? _email;
  String? _password;

  bool get isLoggedIn => _isLoggedIn;

  bool get hasAccount => _email != null && _password != null;

  String? get email => _email;

  bool hasEmail(String email) => _email == email;

  void createAccount({required String email, required String password}) {
    _email = email;
    _password = password;
    _isLoggedIn = true;

    notifyListeners();
  }

  bool login({required String email, required String password}) {
    final isValid = email == _email && password == _password;

    if (!isValid) {
      return false;
    }

    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;

    notifyListeners();
  }
}

