import '../../../../core/auth/auth_login_controller.dart';

enum CreateAccountResult { success, emptyFields, invalidEmail, weakPassword }

class CreateAccount {
  final AuthLoginController authController;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.com$');

  CreateAccount(this.authController);

  Future<CreateAccountResult> call({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return CreateAccountResult.emptyFields;
    }

    if (!_emailRegex.hasMatch(cleanEmail)) {
      return CreateAccountResult.invalidEmail;
    }

    if (cleanPassword.length < 8) {
      return CreateAccountResult.weakPassword;
    }

    authController.createAccount(email: cleanEmail, password: cleanPassword);

    return CreateAccountResult.success;
  }
}

