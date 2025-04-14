import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  User? get currentUser;
  Stream<User?> get authStateChanges;
}
