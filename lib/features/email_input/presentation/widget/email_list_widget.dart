import 'package:flutter/material.dart';
import 'package:emails_sender/features/email_input/domain/entities/email.dart';

class EmailListWidget extends StatelessWidget {
  final List<Email> emails;
  final Function(int) onDelete;

  const EmailListWidget({
    super.key,
    required this.emails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return emails.isEmpty
        ? const Center(
          child: Text(
            "لا توجد إيميلات بعد",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        )
        : ListView.builder(
          itemCount: emails.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(vertical: 4),
              color: const Color(0xFF2D2D2D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.white.withOpacity(0.12)),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: const Color.fromARGB(255, 3, 132, 218),
                ),
                title: Text(
                  emails[index].address,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.87),
                    fontSize: 16,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: const Color(0xFFCF6679),
                  ),
                  onPressed: () => onDelete(index),
                  tooltip: 'حذف',
                ),
              ),
            );
          },
        );
  }
}
