class ApiConfig {
  // Production URL (Render deployment)
  static const String baseUrl = 'https://pawzy-backend.onrender.com';
  
  // Development URL (local testing)
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // iOS simulator
  
  // API endpoints
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String petsEndpoint = '/pets';
}
