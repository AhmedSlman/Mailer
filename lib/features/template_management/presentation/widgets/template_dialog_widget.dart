import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TemplateDialogWidget extends StatefulWidget {
  final Template? template;
  final void Function(String subject, String coverLetter, String cvPath) onSubmit;

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
      backgroundColor: Colors.grey[900], // خلفية الـ Dialog تكون دارك
      title: Text(
        isEdit ? 'تعديل القالب' : 'إضافة قالب جديد',
        style: const TextStyle(color: Colors.white), // لون النص أبيض عشان يبان
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _subjectController,
              style: const TextStyle(color: Colors.white), // لون النص اللي بيكتبه المستخدم أبيض
              decoration: InputDecoration(
                labelText: 'Subject',
                labelStyle: const TextStyle(color: Colors.grey), // لون الـ Label رمادي فاتح
                prefixIcon: const Icon(Icons.subject, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey), // لون الحدود رمادي
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal), // لون الحدود لما يكون فيه فوكس
                ),
                filled: true,
                fillColor: Colors.grey[800], // خلفية الـ TextField دارك
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _coverLetterController,
              maxLines: 5,
              style: const TextStyle(color: Colors.white), // لون النص اللي بيكتبه المستخدم أبيض
              decoration: InputDecoration(
                labelText: 'Cover Letter',
                labelStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.description, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                filled: true,
                fillColor: Colors.grey[800], // خلفية الـ TextField دارك
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _cvPath?.split('/').last ?? 'لم يتم اختيار CV',
                    style: const TextStyle(color: Colors.grey), // لون النص رمادي عشان يبان
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
                    backgroundColor: Colors.teal, // لون الزر ثابت
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
          child: const Text(
            'إلغاء',
            style: TextStyle(color: Colors.grey), // لون زر الإلغاء رمادي
          ),
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

  @override
  void dispose() {
    _subjectController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }
}