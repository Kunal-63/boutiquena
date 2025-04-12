class Env {
  // Toggle this flag to switch between Development and Production
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // API Base URLs
  static const String devApiBaseUrl = "http://69.62.72.21/dev/public/api/";
  static const String prodApiBaseUrl = "http://69.62.72.21/dev/public/api/";

  // Get the current API Base URL based on the environment
  static String get apiBaseUrl => isProduction ? prodApiBaseUrl : devApiBaseUrl;

  // Logging level (Use 'DEBUG' for development, 'PROD' for production)
  static const String logLevel = isProduction ? "PROD" : "DEBUG";
  // Add more environment variables as needed
}
