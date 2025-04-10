import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_state.dart';
import 'package:emails_sender/features/template_management/presentation/widgets/template_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateListComponent extends StatelessWidget {
  const TemplateListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TemplateCubit, TemplateState>(
      listener: (context, state) {
        if (state is TemplateLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث القوالب بنجاح')),
          );
        } else if (state is TemplateError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is TemplateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TemplateError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is TemplateLoaded) {
          return TemplateListWidget(templates: state.templates);
        }
        return const Center(child: Text('لا توجد قوالب بعد'));
      },
    );
  }
}
