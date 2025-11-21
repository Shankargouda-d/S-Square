import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

/// Google Sheet ID
const _spreadsheetId = '110IGwaydHaC1uB37286RRYEG22kayIwXb5ObqqEg9CA';

/// Get GSheets instance from service_account.json
Future<GSheets> getGSheetsInstance() async {
  try {
    final jsonStr = await rootBundle.loadString('assets/service_account.json');
    final credentials = jsonDecode(jsonStr);
    return GSheets(credentials);
  } catch (e) {
    print('Error loading service account JSON: $e');
    rethrow;
  }
}

/// Append word data to Google Sheet
Future<void> appendWordToSheet({
  required String word,
  required String gender,
  required List<String> vibhaktiForms,
}) async {
  try {
    final gsheets = await getGSheetsInstance();
    final ss = await gsheets.spreadsheet(_spreadsheetId);

    final sheet = ss.worksheetByTitle('Sheet1');
    if (sheet == null) {
      print('Sheet1 not found!');
      return;
    }

    await sheet.values.appendRow([
      word,
      gender,
      ...vibhaktiForms,
      DateTime.now().toIso8601String(),
    ]);

    print('Word "$word" added to Google Sheet successfully!');
  } catch (e) {
    print('Error writing to Google Sheet: $e');
  }
}
