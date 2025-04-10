import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/domain/usecase/get_emails.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailInputCubit extends Cubit<List<Email>> {
  final GetEmailsUseCase getEmails;

  EmailInputCubit(this.getEmails) : super([]);

  void loadEmails({String? filePath, String? manualInput}) async {
    final emails = await getEmails(
      filePath: filePath,
      manualInput: manualInput,
    );
    emit(emails);
  }
}
