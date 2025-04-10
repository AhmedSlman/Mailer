import 'package:emails_sender/features/email/data/repo/email_repository_impl.dart';
import 'package:emails_sender/features/email/domain/entities/email.dart';
import 'package:emails_sender/features/email/domain/usecase/get_emails.dart';
import 'package:emails_sender/features/email/presentation/cubit/email_input_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

class EmailInputScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EmailInputCubit(GetEmails(EmailRepositoryImpl())),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إدخال الإيميلات"),
          backgroundColor: Colors.teal,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<EmailInputCubit, List<Email>>(
            listener: (context, emails) {
              // رسائل عند تغيير الحالة
              if (emails.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم تحميل الإيميلات بنجاح")),
                );
              }
            },
            builder: (context, emails) {
              print(
                "Current emails: ${emails.map((email) => email.address).toList()}",
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم الإدخال اليدوي
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
                      print("Manual email input: $value");
                      context.read<EmailInputCubit>().loadEmails(
                        manualInput: value,
                      );
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

                  // قسم تحميل الملفات
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
                      _buildFileButton(
                        context,
                        label: "Excel",
                        icon: Icons.table_chart,
                        extensions: ['xlsx', 'xls'],
                      ),
                      _buildFileButton(
                        context,
                        label: "PDF",
                        icon: Icons.picture_as_pdf,
                        extensions: ['pdf'],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // قائمة الإيميلات
                  Expanded(
                    child:
                        emails.isEmpty
                            ? const Center(
                              child: Text(
                                "لا توجد إيميلات بعد",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: emails.length,
                              itemBuilder: (context, index) {
                                print(
                                  "Displaying email: ${emails[index].address}",
                                );
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.email,
                                      color: Colors.teal,
                                    ),
                                    title: Text(emails[index].address),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        // حذف إيميل معين (محتاج تعديل في Cubit)
                                        // context.read<EmailInputCubit>().removeEmail(index);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لإنشاء أزرار تحميل الملفات
  Widget _buildFileButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required List<String> extensions,
  }) {
    return ElevatedButton.icon(
      onPressed: () async {
        print("Opening file picker for $label...");
        bool isLoading = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: extensions,
          );
          if (result != null) {
            String filePath = result.files.single.path!;
            print("Selected $label file path: $filePath");
            context.read<EmailInputCubit>().loadEmails(filePath: filePath);
          } else {
            print("No $label file selected.");
          }
        } finally {
          isLoading = false;
          Navigator.pop(context); // إغلاق مؤشر التحميل
        }
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
