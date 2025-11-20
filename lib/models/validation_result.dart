class ValidationResult {
  final bool exists;
  final int confidence; // 0-100
  final String? wordType; // commonnoun, propernounname, etc.
  final String message;
  final List<String>? similarWords; // For suggestions

  ValidationResult({
    required this.exists,
    required this.confidence,
    this.wordType,
    required this.message,
    this.similarWords,
  });

  @override
  String toString() {
    return 'ValidationResult(exists: $exists, confidence: $confidence%, message: $message)';
  }
}
