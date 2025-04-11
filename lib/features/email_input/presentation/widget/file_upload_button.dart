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
        try {
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: extensions,
            allowMultiple: false,
          );

          if (result != null && result.files.isNotEmpty) {
            onFileSelected(result.files.first.path!);
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('حدث خطأ أثناء اختيار الملف: $e'),
              backgroundColor: const Color(0xFFCF6679),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      icon: Icon(
        icon,
        color: Colors.white.withOpacity(0.87),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.87),
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2D2D2D),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        side: BorderSide(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
    );
  }
} 