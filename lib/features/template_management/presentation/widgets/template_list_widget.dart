import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/template_management/presentation/component/template_card_component.dart';
import 'package:flutter/material.dart';

class TemplateListWidget extends StatelessWidget {
  final List<Template> templates;

  const TemplateListWidget({super.key, required this.templates});

  @override
  Widget build(BuildContext context) {
    if (templates.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد قوالب بعد، اضغط + لإضافة قالب',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: templates.length,
      itemBuilder: (context, index) {
        return TemplateCardComponent(template: templates[index]);
      },
    );
  }
}
