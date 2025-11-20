import 'package:gsheets/gsheets.dart';

/// ========================
/// CONFIGURATION SECTION
/// ========================

// Paste your service account JSON here as a raw string
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "trim-artifact-478807-r2",
  "private_key_id": "8d02a355f6cf92d9db0b68340bc43593a0412c17",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPuH7IVHRtmv2V\nT0NPx/zfLEcvgTbjsGIPrqW5sPt6DTnifctOOcwidHqAv57BJ+OiRomG2Xc8LQJU\nWwxwyccVk93Zrdxq4zCFXlJ5KaXF7ysFGvOXzs9cosFDjvFGnrKfdcXRzv9Pg7Z8\nI3FJh2q4/U9mhwClrbuHLr98hqaUu6kRUpJi2U2p/1szQOCTUqYzWUtoyXXZi/TV\nCDz7vVjJKoW2Iu74ESPklAkHq8k0IvxpzorB+56qPT7GPOxHa6mW973wTjjnZC54\nRuVAdxILZL/mvI8By5R8sgRIJXzqHd9Tbyb8Lnm0R/jzTEjhnUiWcU6Q8Bq31Liz\n1upE1p7DAgMBAAECggEANvrj391uxbYQ6azFqb/K4D1FiD7gyupcQj9dUSWVomwO\nxrK6FbX5oKMI67wMZp7KwyB9dUppI23cYHyK8e2OetkdDulUXpxMsvhQxw4teRMB\nZYQJNsTAIQpZMisLFMCbkdZn6k0qSZ8YtYniCe7EYjt2ATK5iqDN8o1+lJTFUbdR\n4s/Rx9/6E/yBNdfHi1uBvON091cUTFDAI8bKzWyfJ++DTR3v7joHNFF8FPJMHJ0O\nrYEP9V5k/C2z4ua7yNgD2vQD9f6Ocxsn4fTaZ5bbg9MTJUYMAgmcVVWEmV8OzdfF\n6sbfVsrmwiJhPPliukl5AmiNVYYJuEAvYDdBIyBxaQKBgQDyVgZdqB3za8KOBUmL\nqj4Mr55rpviEYV64b+48S7MPBI0tLIa6vivUKOz4ocKftH6H41v65eVij/7ZTjhW\n5T7rDQDI8LbFbdB21vEKguGWCJb7epTibPNUPPN3r6nN9W5CP4WqJ0rtPt5InwXx\nQvRAGwahsSNq096VOnZBlJ2yiwKBgQDbbtGO3li16cEF531G8oZcRxgBtf6NBUFa\nDP9IOVXNw05ZnOrivMF3GjCPAhbd6MpyBdXPaKT4GLLhZdOuGh8oFrigtxey+Al0\n+zkV81nUueIRP2I48Zb6aFD6sS2pnWfqUCovYQrPxt4hppuiHZ7eLC/23MiPAV5E\n8HzVjBBjqQKBgE+hQuA9oPHe5ARE6oDRRShoANeA+0KMuFJEvXTkrwbtSPKiIfd1\nC/PgKtYcWVafOcCvTgcoyfJUPLrtQAgVtlIIaMyehIBlcE3MnVIF5dimI+6ovgmV\nIXP5v0sB1vtNfZiZRPO/i5hfwyz7zDkV9iqmdsxk561vx0Ej/73W9ua3AoGBAIYJ\nSzhZ2RZFkwJoRL3xpuD3DFL/OF4rt5+qEMWtQBxQEKvsjg2x/vshpEe2nwEuEXtU\n1SW8ZgimDZ5g9MyEaEO0nVKOhIttt1kdm+EspNKsOMsQTI88A10yG0UGtT3GSJN4\nJEyMmm4Qq98iRi7gqQpNM383ncq8qzixLY/D3r8BAoGAQLfhj2GbERvM8KjVDfN9\nQ8Z0xMzcbyrK7Gw5lzvz/cm49G9U2mQ3aNo/pKZcSEmRGXGLlRtKfqRzgW7wso2o\n6gKuCaPbC3h7Ja84ljnTsCpxuqVOcXB9qy5cNzixp5vzkKkUH+d4Ys5zJYoz1GZn\nMS6Fa1AfTtwzRAQSn4sDf/c=\n-----END PRIVATE KEY-----\n",
  "client_email": "fluuter-gshhet-service@trim-artifact-478807-r2.iam.gserviceaccount.com",
  "client_id": "101820585325687500299",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fluuter-gshhet-service%40trim-artifact-478807-r2.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

// Paste your Google Sheet ID from its URL
const _spreadsheetId = '110IGwaydHaC1uB37286RRYEG22kayIwXb5ObqqEg9CA';

/// ========================
/// GOOGLE SHEETS INITIALIZATION
/// ========================
final gsheets = GSheets(_credentials);

/// ========================
/// FUNCTION TO APPEND A WORD
/// ========================
Future<void> appendWordToSheet({
  required String word,
  required String gender,
  required List<String> vibhaktiForms,
}) async {
  try {
    // Open the spreadsheet
    final ss = await gsheets.spreadsheet(_spreadsheetId);

    // Select worksheet by title
    final sheet = ss.worksheetByTitle('Sheet1'); // Make sure this matches your sheet
    if (sheet == null) {
      print('Sheet1 not found!');
      return;
    }

    // Append row: word, gender, 8 vibhakti forms, timestamp
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