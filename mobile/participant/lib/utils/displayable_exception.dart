class DisplayableException implements Exception {
  final String message;
  
  DisplayableException(this.message);

  @override
  String toString() => message;
}