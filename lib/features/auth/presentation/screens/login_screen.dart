import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:emails_sender/features/auth/data/repo/auth_repository_impl.dart';

class LoginScreen extends StatelessWidget {
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Email Sender',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _authRepository.signInWithGoogle();
                  if (context.mounted) {
                    context.go('/');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to sign in: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
} 