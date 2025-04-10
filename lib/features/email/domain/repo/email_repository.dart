import 'package:emails_sender/features/email/domain/entities/email.dart';

abstract class EmailRepository {
  Future<List<Email>> getEmailsFromFile(String filePath);
}
