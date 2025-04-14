import 'package:emails_sender/features/auth/domain/repo/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<UserCredential> call() async {
    return await repository.signInWithGoogle();
  }
}
