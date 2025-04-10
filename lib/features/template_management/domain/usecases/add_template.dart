import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';

class AddTemplateUseCase {
  final TemplateRepository repository;

  AddTemplateUseCase(this.repository);

  Future<void> call(Template template) async =>
      await repository.addTemplate(template);
}
