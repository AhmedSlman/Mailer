import 'package:emails_sender/features/mailer/domain/repo/email_repository.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';

class SendEmails {
  final SendEmailRepository repository;

  SendEmails(this.repository);

  Future<void> call({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required Template template,
  }) async {
    await repository.sendEmails(
      accessToken: accessToken,
      from: from,
      toEmails: toEmails,
      template: template,
    );
  }
}
