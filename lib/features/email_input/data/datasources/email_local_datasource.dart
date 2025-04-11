import 'package:emails_sender/features/email_input/domain/entities/email.dart';

abstract class EmailLocalDataSource {
  Future<List<Email>> getEmailsFromFile(String filePath);
  Future<void> saveEmails(List<Email> emails);
  Future<List<Email>> getSavedEmails();
} 