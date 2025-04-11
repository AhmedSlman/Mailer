import 'package:flutter/material.dart';
import 'package:emails_sender/features/email/domain/entities/email.dart';

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
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    emails[index].address,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
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