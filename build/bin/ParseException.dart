class ParseException implements Exception {
  String message;

  ParseException([this.message]);

  String toString() => '$message';
}