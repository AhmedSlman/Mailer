import 'package:emails_sender/features/auth/domain/repo/auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Map<String, String?>> call() async {
    return await repository.signIn();
  }
}
