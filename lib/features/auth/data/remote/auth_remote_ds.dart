import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<Map<String, String?>> signIn();
  Future<void> signOut();
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/gmail.send'],
  );

  @override
  Future<Map<String, String?>> signIn() async {
    try {
      // تسجيل الدخول بـ Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign-in canceled by user');
      }

      // جلب بيانات التوثيق من Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // إنشاء Credential لـ Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // تسجيل الدخول في Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Firebase');
      }

      return {
        'email': googleUser.email,
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
    } catch (e) {
      if (e is PlatformException) {
        throw Exception('Google Sign-In failed: ${e.message}');
      } else if (e is FirebaseAuthException) {
        throw Exception('Firebase Auth failed: ${e.message}');
      } else {
        throw Exception('Sign-in failed: $e');
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }
}
