class ApiConstants {
  static const String baseUrl = "http://40.66.32.153/go-admin/api/";

  // Timeouts
  static const int connectTimeout = 30;
  static const int receiveTimeout = 30;

  // Headers
  static const String contentType = "application/json";
  static const String accept = "application/json";

  //Login
  static const String loginUrl = "auth/login";
  static const String registerUrl = "auth/register";
  static const String verifyOtpUrl = "auth/verify-otp";
  static const String logoutUrl = "auth/logout";
}
