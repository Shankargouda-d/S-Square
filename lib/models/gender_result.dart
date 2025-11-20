class GenderResult {
  final String gender; // masculine, feminine, neutral, ambiguous, unknown
  final int confidence; // 0-100
  final String method; // Dictionary, Pattern, Combined, Unknown
  final String? vibhaktiClass; // Which vibhakti template to use
  final List<String>? suggestions; // For ambiguous cases

  GenderResult({
    required this.gender,
    required this.confidence,
    required this.method,
    this.vibhaktiClass,
    this.suggestions,
  });

  @override
  String toString() {
    return 'GenderResult(gender: $gender, confidence: $confidence%, method: $method)';
  }
}
