// lib/features/email_input/data/repositories/email_repository_impl.dart
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion;
import 'package:emails_sender/features/email_input/domain/entities/email.dart';
import 'package:emails_sender/features/email_input/domain/repo/email_repository.dart';
import 'package:emails_sender/features/email_input/data/datasources/email_local_datasource.dart';

class EmailRepositoryException implements Exception {
  final String message;
  final dynamic error;

  EmailRepositoryException(this.message, [this.error]);

  @override
  String toString() => 'EmailRepositoryException: $message${error != null ? '\nError: $error' : ''}';
}

class EmailRepositoryImpl implements EmailRepository {
  final EmailLocalDataSource localDataSource;

  EmailRepositoryImpl(this.localDataSource);

  @override
  Future<List<Email>> getEmailsFromFile(String filePath) async {
    try {
      return await localDataSource.getEmailsFromFile(filePath);
    } catch (e) {
      throw EmailRepositoryException('Failed to get emails from file', e);
    }
  }

  @override
  Future<void> saveEmails(List<Email> emails) async {
    try {
      await localDataSource.saveEmails(emails);
    } catch (e) {
      throw EmailRepositoryException('Failed to save emails', e);
    }
  }

  @override
  Future<List<Email>> getSavedEmails() async {
    try {
      return await localDataSource.getSavedEmails();
    } catch (e) {
      throw EmailRepositoryException('Failed to get saved emails', e);
    }
  }
}
