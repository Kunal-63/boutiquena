import 'package:flutter/foundation.dart';

class LogService {
  static void debug(String message) {
    _log("DEBUG", message);
  }

  static void info(String message) {
    _log("INFO", message);
  }

  static void warning(String message) {
    _log("WARNING", message);
  }

  static void error(String message, [StackTrace? stackTrace]) {
    _log("ERROR", message, stackTrace);
  }

  static void critical(String message, [StackTrace? stackTrace]) {
    _log("CRITICAL", message, stackTrace);
  }

  static void _log(String level, String message, [StackTrace? stackTrace]) {
    if (!kReleaseMode) {
      final timestamp = DateTime.now().toIso8601String();
      print("[$timestamp] [$level]: $message");
      if (stackTrace != null) {
        print(stackTrace);
      }
    }
  }
}
