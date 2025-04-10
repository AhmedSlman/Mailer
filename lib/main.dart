import 'package:emails_sender/features/template_management/data/repositories/template_repository_impl.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/view/template_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => TemplateCubit(
            GetTemplatesUseCase(TemplateRepositoryImpl()),
            AddTemplateUseCase(TemplateRepositoryImpl()),
            UpdateTemplateUseCase(TemplateRepositoryImpl()),
            DeleteTemplateUseCase(TemplateRepositoryImpl()),
          ),
      child: MaterialApp(
        home: TemplateScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
