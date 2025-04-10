// lib/features/template_management/data/repositories/template_repository_impl.dart
import 'dart:convert';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  static const String _templatesKey = 'templates';

  @override
  Future<List<Template>> getTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final templatesJson = prefs.getString(_templatesKey) ?? '[]';
    final List<dynamic> templatesList = jsonDecode(templatesJson);
    return templatesList
        .map(
          (json) => Template(
            id: json['id'],
            subject: json['subject'],
            coverLetter: json['coverLetter'],
            cvPath: json['cvPath'],
          ),
        )
        .toList();
  }

  @override
  Future<void> addTemplate(Template template) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplates();
    templates.add(template);
    await prefs.setString(
      _templatesKey,
      jsonEncode(templates.map((t) => t.toJson()).toList()),
    );
  }

  @override
  Future<void> updateTemplate(Template template) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplates();
    final index = templates.indexWhere((t) => t.id == template.id);
    if (index != -1) {
      templates[index] = template;
      await prefs.setString(
        _templatesKey,
        jsonEncode(templates.map((t) => t.toJson()).toList()),
      );
    }
  }

  @override
  Future<void> deleteTemplate(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getTemplates();
    templates.removeWhere((t) => t.id == id);
    await prefs.setString(
      _templatesKey,
      jsonEncode(templates.map((t) => t.toJson()).toList()),
    );
  }
}

extension TemplateExtension on Template {
  Map<String, dynamic> toJson() => {
    'id': id,
    'subject': subject,
    'coverLetter': coverLetter,
    'cvPath': cvPath,
  };
}
