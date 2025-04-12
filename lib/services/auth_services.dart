import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final Uri url = Uri.parse("https://your-api-url.com/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Invalid credentials"};
      }
    } catch (e) {
      return {"error": "Something went wrong"};
    }
  }
}
