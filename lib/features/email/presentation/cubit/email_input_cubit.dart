import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/domain/usecase/get_emails.dart';

class EmailInputState {
  final List<Email> emails;
  final String? error;
  final bool isLoading;

  EmailInputState({
    this.emails = const [],
    this.error,
    this.isLoading = false,
  });

  EmailInputState copyWith({
    List<Email>? emails,
    String? error,
    bool? isLoading,
  }) {
    return EmailInputState(
      emails: emails ?? this.emails,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class EmailInputCubit extends Cubit<EmailInputState> {
  final GetEmailsUseCase getEmailsUseCase;

  EmailInputCubit(this.getEmailsUseCase) : super(EmailInputState());

  Future<void> loadEmails({String? filePath, String? manualInput}) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final emails = await getEmailsUseCase(
        filePath: filePath,
        manualInput: manualInput,
      );
      emit(state.copyWith(emails: emails, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  void removeEmail(int index) {
    final newList = List<Email>.from(state.emails);
    newList.removeAt(index);
    emit(state.copyWith(emails: newList));
  }
}
