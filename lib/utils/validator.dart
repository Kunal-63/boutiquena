class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidMobile(String mobile) {
    final mobileRegex = RegExp(r"^[0-9]{10}$");
    return mobileRegex.hasMatch(mobile);
  }

  static bool isPasswordMatching(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isValidURL(String url) {
    final urlRegex = RegExp(
      r"^(https?:\/\/)?([\da-z.-]+)\.([a-z.]{2,6})([\/\w .-]*)*\/?$",
    );
    return urlRegex.hasMatch(url);
  }
}
