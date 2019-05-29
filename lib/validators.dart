class Validators {
  // static final RegExp _emailRegExp = RegExp(
  //   r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  // );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,}$',
  );

  // static isValidEmail(String email) {
  //   print("=== Checking email validity ===");
  //   return _emailRegExp.hasMatch(email);
  // }

  static isValidPassword(String password) {
    print("=== Checking password validity ===");
    return _passwordRegExp.hasMatch(password);
  }
}
