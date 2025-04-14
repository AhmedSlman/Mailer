import 'dart:convert';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class EmailService {
  Future<void> sendEmail({
    required String accessToken,
    required String from,
    required String to,
    required String subject,
    required String body,
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

      final messageContent = '''
From: $from
To: $to
Subject: $subject
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0

$body
''';

      final base64Email = base64Url.encode(utf8.encode(messageContent));
      final message = Message()..raw = base64Email;

      await gmailApi.users.messages.send(message, 'me');
      authClient.close();
    } catch (e) {
      throw Exception('Failed to send email: $e');
    }
  }
}
