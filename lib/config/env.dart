class Env {
  // Toggle this flag to switch between Development and Production
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // API Base URLs
  static const String devApiBaseUrl = "http://82.29.164.243/api/";
  static const String prodApiBaseUrl = "http://82.29.164.243/api/";

  // Get the current API Base URL based on the environment
  static String get apiBaseUrl => isProduction ? prodApiBaseUrl : devApiBaseUrl;

  // Logging level (Use 'DEBUG' for development, 'PROD' for production)
  static const String logLevel = isProduction ? "PROD" : "DEBUG";
  // Add more environment variables as needed
}
