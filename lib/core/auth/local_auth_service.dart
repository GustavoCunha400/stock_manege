class LocalAuthService {
  static String? _email;
  static String? _password;

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    _email = email;
    _password = password;
  }

  Future<bool> login({required String email, required String password}) async {
    if (_email == null || _password == null) {
      return false;
    }

    return email == _email && password == _password;
  }

  Future<void> clearAccount() async {
    _email = null;
    _password = null;
  }
}

