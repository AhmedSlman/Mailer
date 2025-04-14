abstract class SendEmailRepository {
  Future<void> sendEmails({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required String subject,
    required String coverLetter,
    required String cv,
  });
}
