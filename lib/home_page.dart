import 'package:flutter/material.dart';
import 'data_loader.dart';
import 'services/text_to_speech.dart';
import 'google_sheets_exporter.dart';   // ONLY GOOGLE SHEETS EXPORTER

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> _words = [];
  List<Map<String, String>> _vibhakti = [];

  final TextEditingController _inputController = TextEditingController();

  Map<String, String>? _wordInfo;
  List<String>? _vibhaktiForms;

  bool _isLoading = true;
  String? _error;

  // TTS Service
  final TextToSpeechService _tts = TextToSpeechService();

  // Kannada Vibhakti Names
  final List<String> vibhaktiNamesKannada = [
    "ಪ್ರಥಮಾ",
    "ದ್ವಿತೀಯಾ",
    "ತೃತೀಯಾ",
    "ಚತುರ್ಥೀ",
    "ಪಂಚಮೀ",
    "ಷಷ್ಠೀ",
    "ಸಪ್ತಮೀ",
    "ಸಂಬೋಧನಾ",
  ];

  @override
  void initState() {
    super.initState();
    _tts.initialize();   // IMPORTANT: load voices early
    _loadCSV();
  }

  Future<void> _loadCSV() async {
    _words = await DataLoader.loadWords();
    _vibhakti = await DataLoader.loadVibhakti();

    setState(() {
      _isLoading = false;
    });
  }

  // GOOGLE SHEETS EXPORT FUNCTION
  Future<void> _exportToGoogleSheets() async {
    if (_wordInfo == null || _vibhaktiForms == null) return;

    try {
      await appendWordToSheet(
        word: _wordInfo!['word'] ?? '',
        gender: _wordInfo!['gender'] ?? '',
        vibhaktiForms: _vibhaktiForms!,
      );
      print('Word "${_wordInfo!['word']}" sent to Google Sheets successfully!');
    } catch (e) {
      print('Error sending to Google Sheets: $e');
    }
  }

  void _processWord() async {  // MADE THIS ASYNC
    final w = _inputController.text.trim();

    if (w.isEmpty) {
      setState(() => _error = "Please enter a word.");
      return;
    }

    // Find in words.csv
    final info = _words.firstWhere(
      (e) => e['word'] == w,
      orElse: () => {},
    );

    if (info.isEmpty) {
      setState(() {
        _error = "Word not found in dictionary.";
        _wordInfo = null;
        _vibhaktiForms = null;
      });
      return;
    }

    // Find vibhakti
    final vib = _vibhakti.firstWhere(
      (e) => e['word'] == w,
      orElse: () => {},
    );

    if (vib.isEmpty) {
      setState(() {
        _error = "Vibhakti not available for this word.";
        _wordInfo = info;
        _vibhaktiForms = null;
      });
      return;
    }

    // Collect 8 forms
    final forms = [
      vib['p1'] ?? "",
      vib['p2'] ?? "",
      vib['p3'] ?? "",
      vib['p4'] ?? "",
      vib['p5'] ?? "",
      vib['p6'] ?? "",
      vib['p7'] ?? "",
      vib['p8'] ?? "",
    ];

    setState(() {
      _error = null;
      _wordInfo = info;
      _vibhaktiForms = forms;
    });

    // AUTOMATICALLY EXPORT TO GOOGLE SHEETS AFTER ANALYSIS
    await _exportToGoogleSheets();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Kannada Gender & Vibhakti')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Kannada Gender & Vibhakti Detector"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Box
            TextField(
              controller: _inputController,
              decoration: InputDecoration(
                labelText: "Enter Kannada Word",
                hintText: "ಉದಾ: ಹುಡುಗ, ಮಹಿಳೆ, ಮನೆ",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _processWord,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: _processWord,
              child: Text("Analyze Word"),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
            ),

            SizedBox(height: 20),

            if (_error != null)
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    _error!,
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),

            // WORD INFO
            if (_wordInfo != null)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Word Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Word: ${_wordInfo!['word']}"),
                      Text("Type: ${_wordInfo!['wordType']}"),
                      Text("Gender: ${_wordInfo!['gender']}"),
                      Text("Confidence: ${_wordInfo!['genderConfidence']}%"),
                      Text("Verified: ${_wordInfo!['dictionaryVerified']}"),
                      Text("Vibhakti Class: ${_wordInfo!['vibhaktiClass']}"),
                      if (_wordInfo!['notes'] != null)
                        Text("Notes: ${_wordInfo!['notes']}"),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20),

            // VIBHAKTI FORMS
            if (_vibhaktiForms != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ವಿಭಕ್ತಿ ರೂಪಗಳು (8)",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      for (int i = 0; i < 8; i++)
                        ListTile(
                          leading: CircleAvatar(
                            child: Text("${i + 1}", style: TextStyle(fontSize: 18)),
                          ),
                          title: Text(
                            vibhaktiNamesKannada[i],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            _vibhaktiForms![i],
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.volume_up),
                            onPressed: () {
                              _tts.speakWithLabel(
                                vibhaktiNamesKannada[i],
                                _vibhaktiForms![i],
                              );
                            },
                          ),
                        ),

                      SizedBox(height: 20),

                      // PLAY ALL BUTTON
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_vibhaktiForms != null) {
                              _tts.speakAll(
                                _vibhaktiForms!,
                                vibhaktiNamesKannada,
                              );
                            }
                          },
                          icon: Icon(Icons.volume_up),
                          label: Text(
                            "Play All",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            backgroundColor: Colors.deepOrange,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
