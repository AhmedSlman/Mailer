import 'package:emails_sender/features/auth/data/remote/auth_remote_ds.dart';
import 'package:emails_sender/features/auth/data/repo/auth_repository_impl.dart';
import 'package:emails_sender/features/auth/domain/repo/auth_repository.dart';
import 'package:emails_sender/features/auth/domain/usecase/sign_in.dart';
import 'package:emails_sender/features/auth/domain/usecase/sign_out.dart';
import 'package:emails_sender/features/mailer/data/remote/email_sender.dart';
import 'package:emails_sender/features/mailer/data/repo/email_repository_impl.dart';
import 'package:emails_sender/features/mailer/domain/repo/email_repository.dart';
import 'package:emails_sender/features/mailer/domain/usecase/send_emails.dart';
import 'package:get_it/get_it.dart';
import 'package:emails_sender/features/email_input/data/datasources/email_local_datasource_impl.dart';
import 'package:emails_sender/features/email_input/data/repo/email_repository_impl.dart';
import 'package:emails_sender/features/email_input/domain/repo/email_repository.dart';
import 'package:emails_sender/features/email_input/domain/usecase/get_emails.dart';
import 'package:emails_sender/features/template_management/data/repositories/template_repository_impl.dart';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/email_input/presentation/cubit/email_input_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Email Feature
  // Data Sources
  sl.registerLazySingleton<EmailLocalDataSourceImpl>(
    () => EmailLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl());
  sl.registerLazySingleton<EmailSender>(() => EmailSenderImpl());

  // Repositories
  sl.registerLazySingleton<EmailRepository>(
    () => EmailRepositoryImpl(sl<EmailLocalDataSourceImpl>()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  sl.registerLazySingleton<SendEmailRepository>(
    () => SendEmailRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetEmails(sl<EmailRepository>()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => SendEmails(sl()));

  // Template Management Feature
  // Repositories
  sl.registerLazySingleton<TemplateRepository>(() => TemplateRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton(() => GetTemplatesUseCase(sl<TemplateRepository>()));

  sl.registerLazySingleton(() => AddTemplateUseCase(sl<TemplateRepository>()));

  sl.registerLazySingleton(
    () => UpdateTemplateUseCase(sl<TemplateRepository>()),
  );

  sl.registerLazySingleton(
    () => DeleteTemplateUseCase(sl<TemplateRepository>()),
  );

  // Cubits
  sl.registerFactory(
    () => TemplateCubit(
      sl<GetTemplatesUseCase>(),
      sl<AddTemplateUseCase>(),
      sl<UpdateTemplateUseCase>(),
      sl<DeleteTemplateUseCase>(),
    ),
  );

  sl.registerFactory(() => EmailInputCubit(sl<GetEmailsUseCase>()));
}
