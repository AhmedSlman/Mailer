import 'dart:convert';
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
        final messageContent = '''
From: $from
To: $toEmail
Subject: ${template.subject}
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0

<html>
  <body>
    <h2>Cover Letter</h2>
    <p>${template.coverLetter}</p>
    <h2>CV</h2>
    <p>${template.cvPath}</p>
  </body>
</html>
''';

        final base64Email = base64Url.encode(utf8.encode(messageContent));
        final message = Message()..raw = base64Email;

        await gmailApi.users.messages.send(message, 'me');
        await Future.delayed(Duration(milliseconds: 500));
      }

      authClient.close();
    } catch (e) {
      throw Exception('Failed to send emails: $e');
    }
  }
}
