import 'dart:io';
import 'package:excel/excel.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;
import 'package:emails_sender/features/email_input/domain/entities/email.dart';
import 'package:emails_sender/features/email_input/data/datasources/email_local_datasource.dart';

class FileReadException implements Exception {
  final String message;
  final dynamic error;

  FileReadException(this.message, [this.error]);

  @override
  String toString() => 'FileReadException: $message${error != null ? '\nError: $error' : ''}';
}

class EmailLocalDataSourceImpl implements EmailLocalDataSource {
  final _supportedExtensions = ['.xlsx', '.xls', '.pdf'];
  final _emailPattern = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  @override
  Future<List<Email>> getEmailsFromFile(String filePath) async {
    try {
      _validateFile(filePath);
      
      List<Email> emails = [];
      if (filePath.endsWith('.xlsx') || filePath.endsWith('.xls')) {
        emails = await _readEmailsFromExcel(filePath);
      } else if (filePath.endsWith('.pdf')) {
        emails = await _readEmailsFromPdf(filePath);
      }
      
      return emails;
    } catch (e) {
      throw FileReadException('Failed to read emails from file', e);
    }
  }

  void _validateFile(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileReadException('File does not exist: $filePath');
    }

    final extension = filePath.substring(filePath.lastIndexOf('.'));
    if (!_supportedExtensions.contains(extension)) {
      throw FileReadException('Unsupported file format: $extension');
    }
  }

  Future<List<Email>> _readEmailsFromExcel(String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final emails = <Email>[];

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        if (row.isNotEmpty && row[0] != null) {
          final emailText = row[0]!.value.toString();
          if (_emailPattern.hasMatch(emailText)) {
            emails.add(Email(emailText));
          }
        }
      }
    }
    return emails;
  }

  Future<List<Email>> _readEmailsFromPdf(String filePath) async {
    final file = File(filePath);
    final bytes = file.readAsBytesSync();
    final pdfDoc = syncfusion.PdfDocument(inputBytes: bytes);
    final textExtractor = syncfusion.PdfTextExtractor(pdfDoc);
    final emails = <Email>[];
    
    try {
      for (var i = 0; i < pdfDoc.pages.count; i++) {
        final text = textExtractor.extractText(
          startPageIndex: i,
          endPageIndex: i,
        );
        final matches = _emailPattern.allMatches(text);
        for (var match in matches) {
          emails.add(Email(match.group(0)!));
        }
      }
    } finally {
      pdfDoc.dispose();
    }
    
    return emails;
  }

  @override
  Future<void> saveEmails(List<Email> emails) async {
    // TODO: Implement local storage saving logic
    throw UnimplementedError();
  }

  @override
  Future<List<Email>> getSavedEmails() async {
    // TODO: Implement local storage retrieval logic
    throw UnimplementedError();
  }
} 