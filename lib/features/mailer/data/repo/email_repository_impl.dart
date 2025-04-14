import 'package:emails_sender/features/mailer/data/remote/email_sender.dart';
import 'package:emails_sender/features/mailer/domain/repo/email_repository.dart';

class SendEmailRepositoryImpl implements SendEmailRepository {
  final EmailSender emailSender;

  SendEmailRepositoryImpl(this.emailSender);

  @override
  Future<void> sendEmails({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required String subject,
    required String coverLetter,
    required String cv,
  }) async {
    await emailSender.sendEmails(
      accessToken: accessToken,
      from: from,
      toEmails: toEmails,
      subject: subject,
      coverLetter: coverLetter,
      cv: cv,
    );
  }
}
