// lib/features/template_management/presentation/cubit/template_state.dart
import 'package:emails_sender/features/template_management/domain/entities/template.dart';

abstract class TemplateState {}

class TemplateInitial extends TemplateState {}

class TemplateLoading extends TemplateState {}

class TemplateLoaded extends TemplateState {
  final List<Template> templates;
  TemplateLoaded(this.templates);
}

class TemplateError extends TemplateState {
  final String message;
  TemplateError(this.message);
}
