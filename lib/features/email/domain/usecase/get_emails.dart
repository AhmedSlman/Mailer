// lib/features/email_input/domain/usecases/get_emails.dart

import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/domain/repo/email_repository.dart';

class EmailValidationException implements Exception {
  final String message;

  EmailValidationException(this.message);

  @override
  String toString() => 'EmailValidationException: $message';
}

class GetEmailsException implements Exception {
  final String message;
  final dynamic error;

  GetEmailsException(this.message, [this.error]);

  @override
  String toString() => 'GetEmailsException: $message${error != null ? '\nError: $error' : ''}';
}

abstract class GetEmailsUseCase {
  Future<List<Email>> call({String? filePath, String? manualInput});
}

class GetEmails implements GetEmailsUseCase {
  final EmailRepository repository;

  GetEmails(this.repository);

  @override
  Future<List<Email>> call({String? filePath, String? manualInput}) async {
    try {
      if (filePath != null) {
        return await repository.getEmailsFromFile(filePath);
      } else if (manualInput != null) {
        if (!_isValidEmail(manualInput)) {
          throw EmailValidationException('Invalid email format: $manualInput');
        }
        return [Email(manualInput)];
      }
      return [];
    } on EmailValidationException {
      rethrow;
    } catch (e) {
      throw GetEmailsException('Failed to get emails', e);
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
