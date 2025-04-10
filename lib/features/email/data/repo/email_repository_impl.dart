// lib/features/email_input/data/repositories/email_repository_impl.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;
import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/domain/repo/email_repository.dart';

class EmailRepositoryImpl implements EmailRepository {
  @override
  Future<List<Email>> getEmailsFromFile(String filePath) async {
    try {
      List<Email> emails = [];
      final emailPattern = RegExp(
        r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
      );

      if (filePath.endsWith('.xlsx') || filePath.endsWith('.xls')) {
        // التعامل مع ملفات Excel
        var bytes = File(filePath).readAsBytesSync();
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            if (row.isNotEmpty && row[0] != null) {
              String emailText = row[0]!.value.toString();
              if (emailPattern.hasMatch(emailText)) {
                emails.add(Email(emailText));
              }
            }
          }
        }
      } else if (filePath.endsWith('.pdf')) {
        final file = File(filePath);
        final bytes = file.readAsBytesSync();
        final pdfDoc = syncfusion.PdfDocument(inputBytes: bytes);
        final pageCount = pdfDoc.pages.count;
        print("PDF Pages Count: $pageCount");

        final textExtractor = syncfusion.PdfTextExtractor(pdfDoc);
        for (var i = 0; i < pageCount; i++) {
          final text = textExtractor.extractText(
            startPageIndex: i,
            endPageIndex: i,
          );
          print("Extracted Text from Page ${i + 1}: $text");
          final matches = emailPattern.allMatches(text);
          for (var match in matches) {
            String email = match.group(0)!;
            print("Found Email: $email");
            emails.add(Email(email));
          }
        }
        pdfDoc.dispose();
      }
      print("Final Emails List: $emails");
      return emails;
    } catch (e) {
      print("Error reading file: $e");
      return [];
    }
  }
}
