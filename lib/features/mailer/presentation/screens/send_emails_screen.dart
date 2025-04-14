import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:emails_sender/features/template_management/domain/entities/template.dart';
import 'package:emails_sender/features/mailer/domain/usecase/send_emails.dart';
import 'package:emails_sender/features/mailer/data/repo/email_repository_impl.dart';
import 'package:emails_sender/features/mailer/data/remote/email_sender.dart';

class SendEmailsScreen extends StatefulWidget {
  final List<String> selectedEmails;
  final List<Template> templates;

  const SendEmailsScreen({
    Key? key,
    required this.selectedEmails,
    required this.templates,
  }) : super(key: key);

  @override
  State<SendEmailsScreen> createState() => _SendEmailsScreenState();
}

class _SendEmailsScreenState extends State<SendEmailsScreen> {
  Template? selectedTemplate;
  bool isSending = false;
  final SendEmails sendEmails = SendEmails(
    SendEmailRepositoryImpl(EmailSenderImpl()),
  );

  Future<String> _getAccessToken() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
    if (googleUser == null) {
      throw Exception('User not signed in');
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    return googleAuth.accessToken ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Emails'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Emails: ${widget.selectedEmails.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Template>(
              value: selectedTemplate,
              decoration: const InputDecoration(
                labelText: 'Select Template',
                border: OutlineInputBorder(),
              ),
              items: widget.templates.map((template) {
                return DropdownMenuItem(
                  value: template,
                  child: Text(template.subject),
                );
              }).toList(),
              onChanged: (Template? value) {
                setState(() {
                  selectedTemplate = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSending || selectedTemplate == null
                  ? null
                  : () async {
                      setState(() {
                        isSending = true;
                      });
                      try {
                        final accessToken = await _getAccessToken();
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          throw Exception('User not signed in');
                        }
                        await sendEmails.call(
                          accessToken: accessToken,
                          from: user.email!,
                          toEmails: widget.selectedEmails,
                          template: selectedTemplate!,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Emails sent successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to send emails: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            isSending = false;
                          });
                        }
                      }
                    },
              child: isSending
                  ? const CircularProgressIndicator()
                  : const Text('Send Emails'),
            ),
          ],
        ),
      ),
    );
  }
} 