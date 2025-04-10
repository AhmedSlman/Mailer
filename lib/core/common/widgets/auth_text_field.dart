import 'package:emails_sender/core/common/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextInputType? keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.labelText,
    required this.icon,
    this.isPassword = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10.h),
        CustomTextFormField(
          labelText: labelText,
          hintText: hint,
          isPassword: isPassword,
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
