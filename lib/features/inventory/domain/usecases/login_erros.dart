import '../../../../core/auth/auth_login_controller.dart';

enum LoginErrosResult { success, emptyFields, emailNotRegistered, invalidPassword }

class LoginErros {
  final AuthLoginController authController;

  LoginErros(this.authController);

  Future<LoginErrosResult> call({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return LoginErrosResult.emptyFields;
    }

    if (!authController.hasAccount || !authController.hasEmail(cleanEmail)) {
      return LoginErrosResult.emailNotRegistered;
    }

    final loggedIn = authController.login(
      email: cleanEmail,
      password: cleanPassword,
    );

    if (!loggedIn) {
      return LoginErrosResult.invalidPassword;
    }

    return LoginErrosResult.success;
  }
}

