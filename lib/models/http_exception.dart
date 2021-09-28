class HttpException implements Exception {
  final dynamic message;

  HttpException(this.message);

  String toString() {
    return message;
  }
}
