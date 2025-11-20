import 'models/kannada_word.dart';
import 'models/gender_result.dart';

class GenderDetector {
  final List<KannadaWord> _dictionary;

  GenderDetector(this._dictionary);

  // Main detection method - combines multiple strategies
  GenderResult detect(String word) {
    // Strategy 1: Dictionary lookup (highest confidence)
    final dictResult = _detectFromDictionary(word);
    if (dictResult.confidence >= 90) {
      return dictResult;
    }

    // Strategy 2: Pattern recognition from word endings
    final patternResult = _detectFromPattern(word);
    if (patternResult.confidence >= 70) {
      return patternResult;
    }

    // Strategy 3: Morphological analysis
    final morphResult = _detectFromMorphology(word);
    
    // Return best result
    if (dictResult.confidence > patternResult.confidence && 
        dictResult.confidence > morphResult.confidence) {
      return dictResult;
    } else if (patternResult.confidence > morphResult.confidence) {
      return patternResult;
    } else {
      return morphResult;
    }
  }

  // Strategy 1: Dictionary lookup
  GenderResult _detectFromDictionary(String word) {
    final matches = _dictionary.where((w) => w.word == word.trim()).toList();
    
    if (matches.isNotEmpty) {
      final match = matches.first;
      int confidence = match.genderConfidence == 'high' ? 98 : 
                      match.genderConfidence == 'medium' ? 80 : 60;
      
      return GenderResult(
        gender: match.gender,
        confidence: confidence,
        method: 'Dictionary Lookup',
        vibhaktiClass: match.vibhaktiClass,
      );
    }
    
    return GenderResult(
      gender: 'unknown',
      confidence: 0,
      method: 'Not in Dictionary',
    );
  }

  // Strategy 2: Pattern recognition based on endings
  GenderResult _detectFromPattern(String word) {
    // Masculine patterns
    if (word.endsWith('ನ') || word.endsWith('ನ್')) {
      return GenderResult(
        gender: 'masculine',
        confidence: 75,
        method: 'Ending Pattern (ನ/ನ್)',
        vibhaktiClass: 'classM1',
      );
    }
    
    // Common masculine endings: ಅ
    if (word.endsWith('ಅ')) {
      return GenderResult(
        gender: 'masculine',
        confidence: 70,
        method: 'Ending Pattern (ಅ)',
        vibhaktiClass: 'classM1',
      );
    }

    // Feminine patterns: ಇ, ಈ, ಆ
    if (word.endsWith('ಇ') || word.endsWith('ಈ')) {
      return GenderResult(
        gender: 'feminine',
        confidence: 75,
        method: 'Ending Pattern (ಇ/ಈ)',
        vibhaktiClass: 'classF1',
      );
    }
    
    if (word.endsWith('ಆ')) {
      return GenderResult(
        gender: 'feminine',
        confidence: 70,
        method: 'Ending Pattern (ಆ)',
        vibhaktiClass: 'classF1',
      );
    }

    // Neuter patterns: ಎ, ಏ, ಒ, ಓ, ಉ, ಊ
    if (word.endsWith('ಎ') || word.endsWith('ಏ') || 
        word.endsWith('ಒ') || word.endsWith('ಓ') ||
        word.endsWith('ಉ') || word.endsWith('ಊ')) {
      return GenderResult(
        gender: 'neutral',
        confidence: 70,
        method: 'Ending Pattern (vowel)',
        vibhaktiClass: 'classN1',
      );
    }

    return GenderResult(
      gender: 'ambiguous',
      confidence: 40,
      method: 'No clear pattern',
    );
  }

  // Strategy 3: Morphological analysis
  GenderResult _detectFromMorphology(String word) {
    // Check for common suffixes that indicate gender
    
    // Masculine suffixes
    if (word.contains('ಕ') && word.endsWith('ಕ')) { // e.g., ಬಾಲಕ
      return GenderResult(
        gender: 'masculine',
        confidence: 65,
        method: 'Morphology (ಕ suffix)',
        vibhaktiClass: 'classM1',
      );
    }

    // Feminine suffixes
    if (word.contains('ಕಿ') && word.endsWith('ಕಿ')) { // e.g., ಬಾಲಕಿ
      return GenderResult(
        gender: 'feminine',
        confidence: 65,
        method: 'Morphology (ಕಿ suffix)',
        vibhaktiClass: 'classF1',
      );
    }

    return GenderResult(
      gender: 'unknown',
      confidence: 30,
      method: 'Morphology unclear',
    );
  }

  // Get multiple suggestions for ambiguous words
  List<GenderResult> getAllPossibleGenders(String word) {
    return [
      _detectFromDictionary(word),
      _detectFromPattern(word),
      _detectFromMorphology(word),
    ]..sort((a, b) => b.confidence.compareTo(a.confidence));
  }
}
