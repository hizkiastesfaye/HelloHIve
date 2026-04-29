class Validators {
  Validators._(); // prevents instantiation

  static bool passwordsMatch({
    required String password,
    required String confirmPassword,
  }) {
    return password.trim() == confirmPassword.trim();
  }

  static bool isPasswordValid(String password) {
    return password.length >= 6;
  }
  static bool isNotFieldEmpty(String value){
    return value.trim().isNotEmpty;
  }
  static bool isEmailValid(String email) {
    // Simple regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email.trim());
  }
}
