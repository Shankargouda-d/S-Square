class FormValidator {
  // Validate phonological rules
  bool validatePhonology(String form) {
    // Check for invalid consonant clusters
    // Kannada doesn't allow certain consonant combinations
    
    // Basic check: form should not be empty
    if (form.isEmpty) return false;
    
    // Check if contains only valid Kannada characters
    final kannadaRegex = RegExp(r'^[\u0C80-\u0CFF\s]+$');
    if (!kannadaRegex.hasMatch(form)) return false;
    
    // TODO: Add more sophisticated phonotactic rules
    
    return true;
  }

  // Validate morphological rules
  bool validateMorphology(String form, String gender, String vibhaktiClass) {
    // Check if suffix attachment follows rules
    
    // Masculine words should have specific patterns
    if (gender.toLowerCase() == 'masculine') {
      // Most masculine vibhaktis should contain ನ
      if (vibhaktiClass == 'classM1' && !form.contains('ನ')) {
        // First vibhakti might not have ನ
        return form.endsWith('ನು') || form.contains('ನು');
      }
    }
    
    // Feminine words patterns
    if (gender.toLowerCase() == 'feminine') {
      if (vibhaktiClass == 'classF1' && !form.contains('ಳ') && !form.contains('ಇ')) {
        return false;
      }
    }
    
    return true;
  }

  // Validate consistency across all forms
  bool validateConsistency(List<String> allForms) {
    if (allForms.length != 8) return false;
    
    // All forms should share common root
    // Extract potential root from first form
    String firstForm = allForms[0];
    
    // Check if all other forms start with similar pattern
    for (int i = 1; i < allForms.length; i++) {
      // At least first 2 characters should match (simplified check)
      if (allForms[i].length < 2 || firstForm.length < 2) continue;
      
      // This is a simplified check - in reality, need more sophisticated analysis
      if (!allForms[i].startsWith(firstForm.substring(0, 1))) {
        return false;
      }
    }
    
    return true;
  }

  // Complete validation report
  ValidationReport validate(List<String> forms, String gender, String vibhaktiClass) {
    bool phonoPass = forms.every((f) => validatePhonology(f));
    bool morphoPass = forms.every((f) => validateMorphology(f, gender, vibhaktiClass));
    bool consistPass = validateConsistency(forms);
    
    return ValidationReport(
      phonologicalPass: phonoPass,
      morphologicalPass: morphoPass,
      consistencyPass: consistPass,
    );
  }
}

class ValidationReport {
  final bool phonologicalPass;
  final bool morphologicalPass;
  final bool consistencyPass;

  bool get allValid => phonologicalPass && morphologicalPass && consistencyPass;

  ValidationReport({
    required this.phonologicalPass,
    required this.morphologicalPass,
    required this.consistencyPass,
  });

  String getReport() {
    List<String> issues = [];
    if (!phonologicalPass) issues.add('Phonological rules violated');
    if (!morphologicalPass) issues.add('Morphological rules violated');
    if (!consistencyPass) issues.add('Inconsistent forms');
    
    if (issues.isEmpty) {
      return 'All validations passed ✓';
    } else {
      return 'Issues found: ${issues.join(', ')}';
    }
  }
}
