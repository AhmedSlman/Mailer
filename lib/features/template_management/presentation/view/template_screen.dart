import 'package:emails_sender/features/template_management/data/repositories/template_repository_impl.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/add_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/delete_template.dart';
import 'package:emails_sender/features/template_management/domain/usecases/get_templates.dart';
import 'package:emails_sender/features/template_management/domain/usecases/update_template.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_state.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplateScreen extends StatelessWidget {
  final _subjectController = TextEditingController();
  final _coverLetterController = TextEditingController();
  String? _cvPath;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => TemplateCubit(
            GetTemplatesUseCase(TemplateRepositoryImpl()),
            AddTemplateUseCase(TemplateRepositoryImpl()),
            UpdateTemplateUseCase(TemplateRepositoryImpl()),
            DeleteTemplateUseCase(TemplateRepositoryImpl()),
          )..loadTemplates(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة القوالب'),
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddTemplateDialog(context),
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<TemplateCubit, TemplateState>(
            listener: (context, state) {
              if (state is TemplateLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحديث القوالب بنجاح')),
                );
              } else if (state is TemplateError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is TemplateLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TemplateError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is TemplateLoaded) {
                return state.templates.isEmpty
                    ? const Center(
                      child: Text(
                        'لا توجد قوالب بعد، اضغط + لإضافة قالب',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: state.templates.length,
                      itemBuilder: (context, index) {
                        final template = state.templates[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Colors.teal,
                            ),
                            title: Text(
                              template.subject,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  template.coverLetter,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.attach_file,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        template.cvPath.isEmpty
                                            ? 'بدون CV'
                                            : template.cvPath.split('/').last,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ),
                                  onPressed:
                                      () => _showEditTemplateDialog(
                                        context,
                                        template,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => context
                                          .read<TemplateCubit>()
                                          .deleteTemplate(template.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
              }
              return const Center(child: Text('لا توجد قوالب بعد'));
            },
          ),
        ),
      ),
    );
  }

  void _showAddTemplateDialog(BuildContext context) {
    _subjectController.clear();
    _coverLetterController.clear();
    _cvPath = null;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('إضافة قالب جديد'),
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
                          _cvPath ?? 'لم يتم اختيار CV',
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
                            _cvPath = result.files.single.path;
                            (context as Element)
                                .markNeedsBuild(); // تحديث الـ Dialog
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
                  context.read<TemplateCubit>().addTemplate(
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
                child: const Text('إضافة'),
              ),
            ],
          ),
    );
  }

  void _showEditTemplateDialog(BuildContext context, Template template) {
    _subjectController.text = template.subject;
    _coverLetterController.text = template.coverLetter;
    _cvPath = template.cvPath;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('تعديل القالب'),
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
                            _cvPath = result.files.single.path;
                            (context as Element)
                                .markNeedsBuild(); // تحديث الـ Dialog
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
                  context.read<TemplateCubit>().updateTemplate(
                    Template(
                      id: template.id,
                      subject: _subjectController.text,
                      coverLetter: _coverLetterController.text,
                      cvPath: _cvPath ?? '',
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('حفظ'),
              ),
            ],
          ),
    );
  }
}
