class KannadaWord {
  final String word;
  final String wordType; // commonnoun, propernounname
  final String gender; // masculine, feminine, neutral
  final String genderConfidence; // high, medium, low
  final String dictionaryVerified; // yes, no
  final String vibhaktiClass; // classM1, classF1, classN1, classN2
  final String notes;

  KannadaWord({
    required this.word,
    required this.wordType,
    required this.gender,
    required this.genderConfidence,
    required this.dictionaryVerified,
    required this.vibhaktiClass,
    required this.notes,
  });

  factory KannadaWord.fromCsv(List<dynamic> row) {
    return KannadaWord(
      word: row[0].toString().trim(),
      wordType: row[1].toString().trim(),
      gender: row[2].toString().trim(),
      genderConfidence: row[3].toString().trim(),
      dictionaryVerified: row[4].toString().trim(),
      vibhaktiClass: row[5].toString().trim(),
      notes: row[6].toString().trim(),
    );
  }

  @override
  String toString() {
    return 'KannadaWord(word: $word, gender: $gender, confidence: $genderConfidence)';
  }
}
