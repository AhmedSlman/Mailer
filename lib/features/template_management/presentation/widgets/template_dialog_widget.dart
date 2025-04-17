import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateDialogWidget extends StatefulWidget {
  final Template? template;
  final void Function(String subject, String coverLetter, String cvPath)
  onSubmit;

  const TemplateDialogWidget({
    super.key,
    this.template,
    required this.onSubmit,
  });

  @override
  State<TemplateDialogWidget> createState() => _TemplateDialogWidgetState();
}

class _TemplateDialogWidgetState extends State<TemplateDialogWidget> {
  final _subjectController = TextEditingController();
  final _coverLetterController = TextEditingController();
  String? _cvPath;

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _subjectController.text = widget.template!.subject;
      _coverLetterController.text = widget.template!.coverLetter;
      _cvPath = widget.template!.cvPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.template != null;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        isEdit ? 'تعديل القالب' : 'إضافة قالب جديد',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _subjectController,
              label: 'Subject',
              icon: Icons.subject,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _coverLetterController,
              label: 'Cover Letter',
              icon: Icons.description,
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            _buildCVPicker(context),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(
              _subjectController.text.trim(),
              _coverLetterController.text.trim(),
              _cvPath ?? '',
            );
            final cubit = context.read<TemplateCubit>();
            cubit.loadTemplates();

            // Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(isEdit ? 'حفظ' : 'إضافة'),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }

  Widget _buildCVPicker(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _cvPath?.split('/').last ?? 'لم يتم اختيار CV',
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (result != null) {
                setState(() => _cvPath = result.files.single.path);
              }
            },
            icon: const Icon(Icons.attach_file, size: 18),
            label: const Text('اختيار'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }
}
