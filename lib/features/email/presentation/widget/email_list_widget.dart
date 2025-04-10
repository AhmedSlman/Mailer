import 'package:flutter/material.dart';
import 'package:emails_sender/features/email/domain/entities/email.dart';

class EmailListWidget extends StatelessWidget {
  final List<Email> emails;
  final Function(int)? onDelete;

  const EmailListWidget({
    super.key,
    required this.emails,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return emails.isEmpty
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
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.teal),
                  title: Text(emails[index].address),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete != null ? () => onDelete!(index) : null,
                  ),
                ),
              );
            },
          );
  }
} 