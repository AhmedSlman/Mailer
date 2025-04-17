import 'package:emails_sender/core/di/injection_container.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_cubit.dart';
import 'package:emails_sender/features/template_management/presentation/cubit/template_state.dart';
import 'package:flutter/material.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _coverLetterController = TextEditingController();
  final _cvPathController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _subjectController.dispose();
    _coverLetterController.dispose();
    _cvPathController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addTemplate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final template = Template(
        id: DateTime.now().toString(),
        subject: _subjectController.text,
        coverLetter: _coverLetterController.text,
        cvPath: _cvPathController.text,
      );
      context.read<TemplateCubit>().addTemplate(
        template.subject,
        template.coverLetter,
        template.cvPath,
      );
      _subjectController.clear();
      _coverLetterController.clear();
      _cvPathController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TemplateCubit>()..loadTemplates(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Templates')),
        body: BlocBuilder<TemplateCubit, TemplateState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TemplateCubit>().loadTemplates();
                await Future.delayed(Duration.zero);
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
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
                              onPressed: () => _addTemplate(context),
                              child: const Text('Add Template'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (state is TemplateLoading)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  else if (state is TemplateError)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(state.message),
                        ),
                      ),
                    )
                  else if (state is TemplateLoaded)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final template = state.templates[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: ListTile(
                              title: Text(template.subject),
                              subtitle: Text(template.coverLetter),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<TemplateCubit>()
                                      .deleteTemplate(template.id);
                                },
                              ),
                            ),
                          );
                        },
                        childCount: state.templates.length,
                      ),
                    )
                  else
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No templates available'),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}