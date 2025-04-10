import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/email/data/datasources/email_local_datasource_impl.dart';
import 'package:emails_sender/features/email/data/repo/email_repository_impl.dart';
import 'package:emails_sender/features/email/domain/usecase/get_emails.dart';
import 'package:emails_sender/features/email/presentation/cubit/email_input_cubit.dart';
import 'package:emails_sender/features/email/presentation/component/email_input_component.dart';

class EmailInputScreen extends StatelessWidget {
  const EmailInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailInputCubit(
        GetEmails(
          EmailRepositoryImpl(
            EmailLocalDataSourceImpl(),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدخال الإيميلات"),
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: EmailInputComponent(),
        ),
      ),
    );
  }
}
