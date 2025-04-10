import 'package:emails_sender/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoOrderFound extends StatelessWidget {
  const NoOrderFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 250.h),
          Icon(
            Icons.add_shopping_cart_outlined,
            size: 120.r,
            color: AppColors.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد طلبات حتى الآن',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
