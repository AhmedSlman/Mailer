import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/widgets/template_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showTemplateDialogComponent(BuildContext context, {Template? template}) {
  showDialog(
    context: context,
    builder:
        (_) => TemplateDialogWidget(
          template: template,
          onSubmit: (subject, letter, path) {
            final cubit = context.read<TemplateCubit>();
            if (template == null) {
              cubit.addTemplate(subject, letter, path);
            } else {
              cubit.updateTemplate(
                Template(
                  id: template.id,
                  subject: subject,
                  coverLetter: letter,
                  cvPath: path,
                ),
              );
            }
          },
        ),
  );
}
