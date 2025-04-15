import 'package:emails_sender/features/template_management/presentation/component/template_dialog_component.dart';
import 'package:emails_sender/features/template_management/presentation/component/template_list_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/core/di/injection_container.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';

class TemplateScreen extends StatelessWidget {
  const TemplateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TemplateCubit(
        sl<GetTemplatesUseCase>(),
        sl<AddTemplateUseCase>(),
        sl<UpdateTemplateUseCase>(),
        sl<DeleteTemplateUseCase>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Templates',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.background,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: const TemplateListComponent(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showTemplateDialogComponent(context);
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          label: Text(
            'New Template',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
