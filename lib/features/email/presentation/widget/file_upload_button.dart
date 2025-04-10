import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> extensions;
  final Function(String) onFileSelected;
  final _dialogKey = GlobalKey<NavigatorState>();

  FileUploadButton({
    super.key,
    required this.label,
    required this.icon,
    required this.extensions,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: extensions,
          );
          if (result != null) {
            String filePath = result.files.single.path!;
            onFileSelected(filePath);
          }
        } finally {
          if (context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
          }
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