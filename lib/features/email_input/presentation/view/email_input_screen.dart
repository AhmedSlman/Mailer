import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:emails_sender/core/di/injection_container.dart';
import 'package:emails_sender/features/email_input/domain/usecase/get_emails.dart';
import 'package:emails_sender/features/email_input/presentation/cubit/email_input_cubit.dart';
import 'package:emails_sender/features/email_input/presentation/component/email_input_component.dart';
import 'package:go_router/go_router.dart';

class EmailInputScreen extends StatelessWidget {
  const EmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailInputCubit(sl<GetEmails>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدخال الإيميلات"),
          backgroundColor: Colors.teal,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: EmailInputComponent(),
        ),
      ),
    );
  }
}
