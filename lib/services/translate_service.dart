import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _baseUrl = 'https://libretranslate.com/translate';
  static Future<String> translateText({
    required String text,
    String fromLang = 'auto',
    required String toLang,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source': fromLang,
          'target': toLang,
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['translatedText'] ?? text;
      } else {
        print('Translation failed: ${response.body}');
        return text;
      }
    } catch (e) {
      print('Translation error: $e');
      return text;
    }
  }
}
