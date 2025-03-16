import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  static Future<void> initialize() async {
    // Enable crash reporting only in production
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    // Catch uncaught Flutter errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  // Logs non-fatal errors
  static void logError(dynamic error, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  // Custom log messages
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
}
