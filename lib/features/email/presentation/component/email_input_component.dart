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
            SnackBar(
              content: const Text("تم تحميل الإيميلات بنجاح"),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Manual Input Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "أدخل إيميل يدويًا",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onSubmitted: (value) {
                        context.read<EmailInputCubit>().loadEmails(manualInput: value);
                      },
                      decoration: InputDecoration(
                        hintText: "مثال: example@domain.com",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // File Upload Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تحميل من ملف",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email List
            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "قائمة الإيميلات",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (state.emails.isEmpty)
                        Center(
                          child: Text(
                            "لا توجد إيميلات",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: EmailListWidget(
                            emails: state.emails,
                            onDelete: (index) {
                              context.read<EmailInputCubit>().removeEmail(index);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 