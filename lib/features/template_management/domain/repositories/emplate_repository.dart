import 'package:emails_sender/features/template_management/domain/entities/template.dart';

abstract class TemplateRepository {
  Future<List<Template>> getTemplates();
  Future<void> addTemplate(Template template);
  Future<void> updateTemplate(Template template);
  Future<void> deleteTemplate(String id);
}
