import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LanguageProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _languageKey = 'language';

  String _language = 'en'; // Default language

  String get language => _language;

  /// Constructor loads initial language from secure storage
  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final storedLang = await _storage.read(key: _languageKey);
    _language = storedLang ?? 'en';
    notifyListeners();
  }

  /// Set and save language
  Future<void> setLanguage(String langCode) async {
    _language = langCode;
    await _storage.write(key: _languageKey, value: langCode);
    notifyListeners();
  }

  /// Delete stored language
  Future<void> deleteLanguage() async {
    await _storage.delete(key: _languageKey);
    _language = 'en';
    notifyListeners();
  }

  /// Helpers
  bool get isArabic => _language == 'ar';
  bool get isEnglish => _language == 'en';
  bool get isHebrew => _language == 'he';
}
