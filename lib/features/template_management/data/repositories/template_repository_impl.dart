// lib/features/template_management/data/repositories/template_repository_impl.dart
import 'dart:convert';
import 'package:emails_sender/features/template_management/domain/repositories/emplate_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  static const String _templatesKey = 'templates';

  @override
  Future<List<Template>> getTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesJson = prefs.getString(_templatesKey);
      
      if (templatesJson == null) {
        // Initialize with empty list if no templates exist
        await prefs.setString(_templatesKey, '[]');
        return [];
      }
      
      final List<dynamic> templatesList = jsonDecode(templatesJson);
      return templatesList
          .map(
            (json) => Template(
              id: json['id'] as String,
              subject: json['subject'] as String,
              coverLetter: json['coverLetter'] as String,
              cvPath: json['cvPath'] as String,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get templates: $e');
    }
  }

  @override
  Future<void> addTemplate(Template template) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templates = await getTemplates();
      templates.add(template);
      await prefs.setString(
        _templatesKey,
        jsonEncode(templates.map((t) => t.toJson()).toList()),
      );
    } catch (e) {
      throw Exception('Failed to add template: $e');
    }
  }

  @override
  Future<void> updateTemplate(Template template) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templates = await getTemplates();
      final index = templates.indexWhere((t) => t.id == template.id);
      if (index != -1) {
        templates[index] = template;
        await prefs.setString(
          _templatesKey,
          jsonEncode(templates.map((t) => t.toJson()).toList()),
        );
      } else {
        throw Exception('Template not found');
      }
    } catch (e) {
      throw Exception('Failed to update template: $e');
    }
  }

  @override
  Future<void> deleteTemplate(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templates = await getTemplates();
      final initialLength = templates.length;
      templates.removeWhere((t) => t.id == id);
      
      if (templates.length == initialLength) {
        throw Exception('Template not found');
      }
      
      await prefs.setString(
        _templatesKey,
        jsonEncode(templates.map((t) => t.toJson()).toList()),
      );
    } catch (e) {
      throw Exception('Failed to delete template: $e');
    }
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
