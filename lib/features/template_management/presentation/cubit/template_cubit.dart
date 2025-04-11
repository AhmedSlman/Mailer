// lib/features/template_management/presentation/cubit/template_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_state.dart';
import 'package:uuid/uuid.dart';

class TemplateCubit extends Cubit<TemplateState> {
  final GetTemplatesUseCase _getTemplates;
  final AddTemplateUseCase _addTemplate;
  final UpdateTemplateUseCase _updateTemplate;
  final DeleteTemplateUseCase _deleteTemplate;

  TemplateCubit(
    this._getTemplates,
    this._addTemplate,
    this._updateTemplate,
    this._deleteTemplate,
  ) : super(TemplateInitial()) {
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    emit(TemplateLoading());
    try {
      final templates = await _getTemplates();
      if (templates.isEmpty) {
        emit(TemplateLoaded([]));
      } else {
        emit(TemplateLoaded(templates));
      }
    } catch (e) {
      emit(TemplateError('حدث خطأ أثناء تحميل القوالب: $e'));
    }
  }

  Future<void> addTemplate(
    String subject,
    String coverLetter,
    String cvPath,
  ) async {
    try {
      final template = Template(
        id: const Uuid().v4(),
        subject: subject,
        coverLetter: coverLetter,
        cvPath: cvPath,
      );
      await _addTemplate(template);
      
      // Update the current state with the new template
      if (state is TemplateLoaded) {
        final currentTemplates = (state as TemplateLoaded).templates;
        final updatedTemplates = [...currentTemplates, template];
        emit(TemplateLoaded(updatedTemplates));
      } else {
        final templates = await _getTemplates();
        emit(TemplateLoaded(templates));
      }
    } catch (e) {
      emit(TemplateError('حدث خطأ أثناء إضافة القالب: $e'));
    }
  }

  Future<void> updateTemplate(Template template) async {
    try {
      await _updateTemplate(template);
      if (state is TemplateLoaded) {
        final currentTemplates = (state as TemplateLoaded).templates;
        final index = currentTemplates.indexWhere((t) => t.id == template.id);
        if (index != -1) {
          final updatedTemplates = [...currentTemplates];
          updatedTemplates[index] = template;
          emit(TemplateLoaded(updatedTemplates));
        }
      } else {
        final templates = await _getTemplates();
        emit(TemplateLoaded(templates));
      }
    } catch (e) {
      emit(TemplateError('حدث خطأ أثناء تعديل القالب: $e'));
    }
  }

  Future<void> deleteTemplate(String id) async {
    try {
      await _deleteTemplate(id);
      if (state is TemplateLoaded) {
        final currentTemplates = (state as TemplateLoaded).templates;
        final updatedTemplates = currentTemplates.where((t) => t.id != id).toList();
        emit(TemplateLoaded(updatedTemplates));
      } else {
        final templates = await _getTemplates();
        emit(TemplateLoaded(templates));
      }
    } catch (e) {
      emit(TemplateError('حدث خطأ أثناء حذف القالب: $e'));
    }
  }
}
