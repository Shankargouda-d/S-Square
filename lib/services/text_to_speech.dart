import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Set basic properties
    await _tts.setLanguage("kn-IN");
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    // Fetch all voices
    List<dynamic> voices = await _tts.getVoices;

    print("📢 All Available Voices:");
    for (var v in voices) {
      print(v);
    }

    // Try to pick the best Kannada male voice
    Map? selectedVoice;

    for (var v in voices) {
      if (v["locale"] == "kn-IN" && v["name"].toString().contains("male")) {
        selectedVoice = v;
        break;
      }
    }

    // If no explicit "male" voice, pick any kn-IN voice
    selectedVoice ??=
        voices.firstWhere((v) => v["locale"] == "kn-IN", orElse: () => null);

    if (selectedVoice != null) {
      print("🎯 Selected Kannada Voice: ${selectedVoice["name"]}");
      await _tts.setVoice({
        "name": selectedVoice["name"],
        "locale": selectedVoice["locale"]
      });
    } else {
      print("⚠ No Kannada voice available. Using default.");
    }

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await initialize();
    await _tts.speak(text);
  }

  Future<void> speakWithLabel(String label, String form) async {
    await initialize();
    await _tts.speak(label);
    await Future.delayed(Duration(milliseconds: 500));
    await _tts.speak(form);
  }

  Future<void> speakAll(
      List<String> forms, List<String> vibhaktiNames) async {
    await initialize();

    for (int i = 0; i < forms.length; i++) {
      await _tts.speak(vibhaktiNames[i]);
      await Future.delayed(Duration(milliseconds: 500));
      await _tts.speak(forms[i]);
      await Future.delayed(Duration(milliseconds: 900));
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
