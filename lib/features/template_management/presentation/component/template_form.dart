import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:file_picker/file_picker.dart';

class TemplateForm extends StatefulWidget {
  final Template? template;

  const TemplateForm({super.key, this.template});

  @override
  State<TemplateForm> createState() => _TemplateFormState();
}

class _TemplateFormState extends State<TemplateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _subjectController;
  late TextEditingController _coverLetterController;
  String? _cvPath;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(text: widget.template?.subject);
    _coverLetterController = TextEditingController(text: widget.template?.coverLetter);
    _cvPath = widget.template?.cvPath;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _cvPath = result.files.first.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء اختيار الملف: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.template == null ? 'إضافة قالب' : 'تعديل القالب',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _subjectController,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                labelText: 'عنوان الرسالة',
                labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال عنوان الرسالة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _coverLetterController,
              style: TextStyle(color: colorScheme.onSurface),
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'نص الرسالة',
                labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال نص الرسالة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: _cvPath == null
                      ? colorScheme.outline.withOpacity(0.5)
                      : colorScheme.primary,
                ),
              ),
              child: InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.attach_file,
                            color: _cvPath == null
                                ? colorScheme.outline.withOpacity(0.5)
                                : colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ملف السيرة الذاتية',
                            style: TextStyle(
                              color: _cvPath == null
                                  ? colorScheme.outline.withOpacity(0.5)
                                  : colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      if (_cvPath != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _cvPath!.split('/').last,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (widget.template == null) {
                    context.read<TemplateCubit>().addTemplate(
                          _subjectController.text,
                          _coverLetterController.text,
                          _cvPath ?? '',
                        );
                  } else {
                    context.read<TemplateCubit>().updateTemplate(
                          Template(
                            id: widget.template!.id,
                            subject: _subjectController.text,
                            coverLetter: _coverLetterController.text,
                            cvPath: _cvPath ?? '',
                          ),
                        );
                  }
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.template == null ? 'إضافة' : 'تحديث',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 