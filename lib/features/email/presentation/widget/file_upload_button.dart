import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<String> extensions;
  final Function(String) onFileSelected;

  const FileUploadButton({
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
            onFileSelected(filePath);
          }
        } finally {
          isLoading = false;
          Navigator.pop(context);
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