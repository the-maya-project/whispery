/// Helper class to validate textformfield inputs.
class Validators {
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$',
  );

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
