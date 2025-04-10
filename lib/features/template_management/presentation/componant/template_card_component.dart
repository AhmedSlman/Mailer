import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/presentation/componant/template_dialog_component.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/widgets/template_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateCardComponent extends StatelessWidget {
  final Template template;

  const TemplateCardComponent({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return TemplateCardWidget(
      template: template,
      onEdit: () => showTemplateDialogComponent(context, template: template),
      onDelete: () => context.read<TemplateCubit>().deleteTemplate(template.id),
    );
  }
}
