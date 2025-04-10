import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';

class DeleteTemplateUseCase {
  final TemplateRepository repository;

  DeleteTemplateUseCase(this.repository);

  Future<void> call(String id) async => await repository.deleteTemplate(id);
}
