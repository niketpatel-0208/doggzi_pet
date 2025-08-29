class ApiConfig {
  // Update this URL after deploying to Render
  static const String productionApiUrl = "https://pawzy-backend.onrender.com";

  // Development URLs
  static const String localApiUrl = "http://localhost:8000";
  static const String androidEmulatorUrl = "http://10.0.2.2:8000";

  // Choose the appropriate URL based on build mode
  static String get baseUrl {
    // In production/release mode, use the production URL
    if (const bool.fromEnvironment('dart.vm.product')) {
      return productionApiUrl;
    }

    // For development, use local URL
    return localApiUrl;
  }
}
