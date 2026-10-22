class HttpHelperException implements Exception {
  final String message;
  final int? statusCode;

  HttpHelperException(this.message, this.statusCode);

  @override
  String toString() {
    final status = statusCode == null
        ? 'HTTP request failed'
        : 'HTTP request failed with status code $statusCode';
    return '$status. $message';
  }
}
