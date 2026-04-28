class ApiResponse<T> {
  final bool status;
  final T? data;
  final String? message;

  ApiResponse({required this.status, this.data, this.message});

  factory ApiResponse.success(T data) {
    return ApiResponse(status: true, data: data);
  }

  factory ApiResponse.failure(String message) {
    return ApiResponse(status: false, message: message);
  }
}
