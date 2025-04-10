// lib/features/email_input/domain/usecases/get_emails.dart

import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/domain/repo/email_repository.dart';

abstract class GetEmailsUseCase {
  Future<List<Email>> call({String? filePath, String? manualInput});
}

class GetEmails implements GetEmailsUseCase {
  final EmailRepository repository;

  GetEmails(this.repository);

  @override
  Future<List<Email>> call({String? filePath, String? manualInput}) async {
    if (filePath != null) {
      return await repository.getEmailsFromFile(filePath);
    } else if (manualInput != null) {
      return [Email(manualInput)];
    }
    return [];
  }
}
