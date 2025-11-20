import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class DataLoader {

  static Future<List<Map<String, String>>> loadWords() async {
    final raw = await rootBundle.loadString('assets/words.csv');
    final rows = const CsvToListConverter().convert(raw);

    final headers = rows.first.cast<String>();
    rows.removeAt(0);

    return rows.map((row) {
      final map = <String, String>{};
      for (int i = 0; i < headers.length; i++) {
        map[headers[i]] = row[i].toString();
      }
      return map;
    }).toList();
  }

  static Future<List<Map<String, String>>> loadVibhakti() async {
    final raw = await rootBundle.loadString('assets/vibhakti.csv');
    final rows = const CsvToListConverter().convert(raw);

    final headers = rows.first.cast<String>();
    rows.removeAt(0);

    return rows.map((row) {
      final map = <String, String>{};
      for (int i = 0; i < headers.length; i++) {
        map[headers[i]] = row[i].toString();
      }
      return map;
    }).toList();
  }
}
