import 'package:flutter/material.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/usecases/login_erros.dart';

class LoginFormController extends ChangeNotifier {
  LoginFormController({required LoginErros loginErros})
      : _loginErros = loginErros;

  final LoginErros _loginErros;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? loginError;
  String? passwordError;
  String? loginEmpty;
  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void clearEmailErrors(String _) {
    if (loginError == null && loginEmpty == null) return;

    loginError = null;
    loginEmpty = null;
    notifyListeners();
  }

  void clearPasswordErrors(String _) {
    if (passwordError == null && loginEmpty == null) return;

    passwordError = null;
    loginEmpty = null;
    notifyListeners();
  }

  Future<bool> submit(AppLocalizations l10n) async {
    loginError = null;
    passwordError = null;
    loginEmpty = null;

    final result = await _loginErros(
      email: emailController.text,
      password: passwordController.text,
    );

    switch (result) {
      case LoginErrosResult.success:
        notifyListeners();
        return true;
      case LoginErrosResult.emptyFields:
        loginEmpty = l10n.loginEmptyFields;
      case LoginErrosResult.emailNotRegistered:
        loginError = l10n.emailNotRegistered;
      case LoginErrosResult.invalidPassword:
        passwordError = l10n.invalidEmailPassword;
    }

    notifyListeners();
    return false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
