import 'package:get_it/get_it.dart';
import 'package:emails_sender/features/email/data/datasources/email_local_datasource_impl.dart';
import 'package:emails_sender/features/email/data/repo/email_repository_impl.dart';
import 'package:emails_sender/features/email/domain/repo/email_repository.dart';
import 'package:emails_sender/features/email/domain/usecase/get_emails.dart';
import 'package:emails_sender/features/template_management/data/repositories/template_repository_impl.dart';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Email Feature
  // Data Sources
  sl.registerLazySingleton<EmailLocalDataSourceImpl>(
    () => EmailLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(
      sl<EmailLocalDataSourceImpl>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetEmails(sl<EmailRepository>()),
  );

  // Template Management Feature
  // Repositories
  sl.registerLazySingleton<TemplateRepository>(
    () => TemplateRepositoryImpl(),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetTemplatesUseCase(sl<TemplateRepository>()),
  );
  
  sl.registerLazySingleton(
    () => AddTemplateUseCase(sl<TemplateRepository>()),
  );
  
  sl.registerLazySingleton(
    () => UpdateTemplateUseCase(sl<TemplateRepository>()),
  );
  
  sl.registerLazySingleton(
    () => DeleteTemplateUseCase(sl<TemplateRepository>()),
  );
} 