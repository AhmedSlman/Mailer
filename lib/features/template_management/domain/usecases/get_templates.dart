import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';

class GetTemplatesUseCase {
  final TemplateRepository repository;

  GetTemplatesUseCase(this.repository);

  Future<List<Template>> call() async => await repository.getTemplates();
}
