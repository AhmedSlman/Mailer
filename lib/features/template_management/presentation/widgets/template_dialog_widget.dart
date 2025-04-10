import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
      title: Text(isEdit ? 'تعديل القالب' : 'إضافة قالب جديد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                prefixIcon: const Icon(Icons.subject),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _coverLetterController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Cover Letter',
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _cvPath?.split('/').last ?? 'لم يتم اختيار CV',
                    style: const TextStyle(color: Colors.grey),
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
                  icon: const Icon(Icons.attach_file),
                  label: const Text('CV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(
              _subjectController.text,
              _coverLetterController.text,
              _cvPath ?? '',
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          child: Text(isEdit ? 'حفظ' : 'إضافة'),
        ),
      ],
    );
  }
}
