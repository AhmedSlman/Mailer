import 'package:emails_sender/features/mailer/domain/repo/email_repository.dart';

class SendEmails {
  final SendEmailRepository repository;

  SendEmails(this.repository);

  Future<void> call({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required String subject,
    required String coverLetter,
    required String cv,
  }) async {
    await repository.sendEmails(
      accessToken: accessToken,
      from: from,
      toEmails: toEmails,
      subject: subject,
      coverLetter: coverLetter,
      cv: cv,
    );
  }
}
