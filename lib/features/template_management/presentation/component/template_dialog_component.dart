import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_state.dart';
import 'package:emails_sender/features/template_management/presentation/widgets/template_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showTemplateDialogComponent(BuildContext context, {Template? template}) {
  showDialog(
    context: context,
    builder: (dialogContext) => WillPopScope(
      onWillPop: () async => false,
      child: TemplateDialogWidget(
        template: template,
        onSubmit: (subject, letter, path) {
          final cubit = context.read<TemplateCubit>();
          // Show loading state immediately
          cubit.emit(TemplateLoading());
          
          if (template == null) {
            cubit.addTemplate(subject, letter, path).then((_) {
              Navigator.of(dialogContext).pop();
              cubit.loadTemplates();
            });
          } else {
            cubit.updateTemplate(
              Template(
                id: template.id,
                subject: subject,
                coverLetter: letter,
                cvPath: path,
              ),
            ).then((_) {
              Navigator.of(dialogContext).pop();
              cubit.loadTemplates();
            });
          }
        },
      ),
    ),
  );
}
