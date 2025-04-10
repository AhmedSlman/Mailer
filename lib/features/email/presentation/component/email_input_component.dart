import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/presentation/cubit/email_input_cubit.dart';
import 'package:emails_sender/features/email/presentation/widget/email_list_widget.dart';
import 'package:emails_sender/features/email/presentation/widget/file_upload_button.dart';

class EmailInputComponent extends StatelessWidget {
  const EmailInputComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailInputCubit, EmailInputState>(
      listener: (context, state) {
        if (state.emails.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تحميل الإيميلات بنجاح")),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Manual Input Section
            const Text(
              "أدخل إيميل يدويًا",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onSubmitted: (value) {
                context.read<EmailInputCubit>().loadEmails(manualInput: value);
              },
              decoration: InputDecoration(
                hintText: "مثال: example@domain.com",
                prefixIcon: const Icon(Icons.email, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 20),

            // File Upload Section
            const Text(
              "تحميل من ملف",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FileUploadButton(
                  label: "Excel",
                  icon: Icons.table_chart,
                  extensions: ['xlsx', 'xls'],
                  onFileSelected: (filePath) {
                    context.read<EmailInputCubit>().loadEmails(filePath: filePath);
                  },
                ),
                FileUploadButton(
                  label: "PDF",
                  icon: Icons.picture_as_pdf,
                  extensions: ['pdf'],
                  onFileSelected: (filePath) {
                    context.read<EmailInputCubit>().loadEmails(filePath: filePath);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email List
            Expanded(
              child: EmailListWidget(
                emails: state.emails,
                onDelete: (index) {
                  context.read<EmailInputCubit>().removeEmail(index);
                },
              ),
            ),
          ],
        );
      },
    );
  }
} 