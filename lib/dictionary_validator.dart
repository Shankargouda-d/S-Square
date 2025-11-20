import 'models/kannada_word.dart';
import 'models/validation_result.dart';

class DictionaryValidator {
  final List<KannadaWord> _dictionary;

  DictionaryValidator(this._dictionary);

  // Exact match validation
  ValidationResult validateExact(String word) {
    final trimmedWord = word.trim();
    
    final matches = _dictionary.where((w) => w.word == trimmedWord).toList();
    
    if (matches.isNotEmpty) {
      final match = matches.first;
      return ValidationResult(
        exists: true,
        confidence: 100,
        wordType: match.wordType,
        message: 'Word found in dictionary (${match.wordType})',
      );
    }
    
    // Try finding similar words
    final similar = _findSimilarWords(trimmedWord);
    
    return ValidationResult(
      exists: false,
      confidence: 0,
      message: similar.isEmpty 
          ? 'Word not found in dictionary' 
          : 'Word not found. Did you mean one of these?',
      similarWords: similar,
    );
  }

  // Fuzzy matching for typos/suggestions
  List<String> _findSimilarWords(String word) {
    List<String> similar = [];
    
    for (var dictWord in _dictionary) {
      // Simple similarity: same starting character and similar length
      if (dictWord.word.startsWith(word.substring(0, 1)) &&
          (dictWord.word.length - word.length).abs() <= 2) {
        similar.add(dictWord.word);
      }
      
      if (similar.length >= 5) break; // Limit suggestions
    }
    
    return similar;
  }

  // Check if word type matches expectations
  bool isCommonNoun(String word) {
    final match = _dictionary.where((w) => w.word == word).firstOrNull;
    return match?.wordType == 'commonnoun';
  }

  bool isProperName(String word) {
    final match = _dictionary.where((w) => w.word == word).firstOrNull;
    return match?.wordType == 'propernounname';
  }

  // Get all words of specific gender
  List<KannadaWord> getWordsByGender(String gender) {
    return _dictionary.where((w) => w.gender.toLowerCase() == gender.toLowerCase()).toList();
  }

  // Statistics
  Map<String, int> getStatistics() {
    int masculine = _dictionary.where((w) => w.gender == 'masculine').length;
    int feminine = _dictionary.where((w) => w.gender == 'feminine').length;
    int neutral = _dictionary.where((w) => w.gender == 'neutral').length;
    
    return {
      'total': _dictionary.length,
      'masculine': masculine,
      'feminine': feminine,
      'neutral': neutral,
    };
  }
}
