import 'package:flutter/material.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final List<Template> _templates = [];
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _coverLetterController = TextEditingController();
  final _cvPathController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _coverLetterController.dispose();
    _cvPathController.dispose();
    super.dispose();
  }

  void _addTemplate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _templates.add(
          Template(
            id: DateTime.now().toString(),
            subject: _subjectController.text,
            coverLetter: _coverLetterController.text,
            cvPath: _cvPathController.text,
          ),
        );
      });
      _subjectController.clear();
      _coverLetterController.clear();
      _cvPathController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Templates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _coverLetterController,
                    decoration: const InputDecoration(
                      labelText: 'Cover Letter',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a cover letter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cvPathController,
                    decoration: const InputDecoration(
                      labelText: 'CV Path',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a CV path';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addTemplate,
                    child: const Text('Add Template'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  return Card(
                    child: ListTile(
                      title: Text(template.subject),
                      subtitle: Text(template.coverLetter),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _templates.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 