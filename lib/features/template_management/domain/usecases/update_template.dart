import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';

class UpdateTemplateUseCase {
  final TemplateRepository repository;

  UpdateTemplateUseCase(this.repository);

  Future<void> call(Template template) async =>
      await repository.updateTemplate(template);
}
