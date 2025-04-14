import 'package:emails_sender/features/template_management/domain/entities/template.dart';

abstract class SendEmailRepository {
  Future<void> sendEmails({
    required String accessToken,
    required String from,
    required List<String> toEmails,
    required Template template,
  });
}
