import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emails_sender/features/email_input/domain/entities/email.dart';
import 'package:emails_sender/features/email_input/presentation/cubit/email_input_cubit.dart';
import 'package:emails_sender/features/email_input/presentation/widget/email_list_widget.dart';
import 'package:emails_sender/features/email_input/presentation/widget/file_upload_button.dart';

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
              backgroundColor: const Color(0xFF03DAC5),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
              elevation: 1,
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.edit_note,
                          color: const Color(0xFF03DAC5),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "إدخال يدوي",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onSubmitted: (value) {
                        context.read<EmailInputCubit>().loadEmails(manualInput: value);
                      },
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.87),
                      ),
                      decoration: InputDecoration(
                        hintText: "مثال: example@domain.com",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                          color: const Color(0xFF03DAC5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF03DAC5),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF2D2D2D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // File Upload Section
            Card(
              elevation: 1,
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.upload_file,
                          color: const Color(0xFF03DAC5),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "تحميل من ملف",
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.87),
                          ),
                        ),
                      ],
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
                elevation: 1,
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt,
                            color: const Color(0xFF03DAC5),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "قائمة الإيميلات",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.87),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state.emails.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 48,
                                color: Colors.white.withOpacity(0.38),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "لا توجد إيميلات",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
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