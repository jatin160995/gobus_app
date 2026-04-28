class ApiException implements Exception {
  final String message;
  ApiException(this.message);
}

class NoInternetException extends ApiException {
  NoInternetException() : super("No internet connection");
}

class TimeoutException extends ApiException {
  TimeoutException() : super("Request timeout");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException() : super("Unauthorized access");
}

class ServerException extends ApiException {
  ServerException(String message) : super(message);
}
