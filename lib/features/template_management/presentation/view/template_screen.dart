import 'package:emails_sender/features/template_management/data/repositories/template_repository_impl.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';
import 'package:emails_sender/features/template_management/presentation/componant/template_dialog_component.dart';
import 'package:emails_sender/features/template_management/presentation/componant/template_list_component.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => TemplateCubit(
            GetTemplatesUseCase(TemplateRepositoryImpl()),
            AddTemplateUseCase(TemplateRepositoryImpl()),
            UpdateTemplateUseCase(TemplateRepositoryImpl()),
            DeleteTemplateUseCase(TemplateRepositoryImpl()),
          )..loadTemplates(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة القوالب'),
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showTemplateDialogComponent(context),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: TemplateListComponent(),
        ),
      ),
    );
  }
}
