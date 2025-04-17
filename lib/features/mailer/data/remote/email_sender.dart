import 'dart:convert';
import 'dart:io';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:emails_sender/features/template_management/domain/entities/template.dart';

abstract class EmailSender {
  Future<void> sendEmails({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required Template template,
  });
}

class EmailSenderImpl implements EmailSender {
  @override
  Future<void> sendEmails({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required Template template,
  }) async {
    try {
      final authClient = authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken(
            'Bearer',
            accessToken,
            DateTime.now().toUtc().add(Duration(hours: 1)),
          ),
          null,
          ['https://www.googleapis.com/auth/gmail.send'],
        ),
      );

      final gmailApi = GmailApi(authClient);

      for (String toEmail in toEmails) {
        final message = Message();
        final boundary = 'boundary_${DateTime.now().millisecondsSinceEpoch}';

        // Read the CV file
        final cvFile = File(template.cvPath);
        final cvBytes = await cvFile.readAsBytes();
        final cvBase64 = base64Encode(cvBytes);

        // Create multipart message
        final messageContent = '''
From: $from
To: $toEmail
Subject: ${template.subject}
Content-Type: multipart/mixed; boundary=$boundary

--$boundary
Content-Type: text/html; charset="utf-8"

<html>
  <body>
    <p>${template.coverLetter}</p>
  </body>
</html>

--$boundary
Content-Type: application/pdf
Content-Disposition: attachment; filename="${cvFile.path.split('/').last}"
Content-Transfer-Encoding: base64

$cvBase64

--$boundary--
''';

        final base64Email = base64Url.encode(utf8.encode(messageContent));
        message.raw = base64Email;

        await gmailApi.users.messages.send(message, 'me');
        await Future.delayed(Duration(milliseconds: 500));
      }

      authClient.close();
    } catch (e) {
      throw Exception('Failed to send emails: $e');
    }
  }
}
