import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key, this.onPressed, this.icon});
  final void Function()? onPressed;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.fillGrey,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتج',
                  hintStyle: TextStyle(color: AppColors.grey),
                  prefixIcon: Icon(Icons.search, color: AppColors.fillGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            height: 45.h,
            width: 45.w,
            decoration: BoxDecoration(
              color: AppColors.fillGrey,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: IconButton(
              icon: Icon(icon, color: AppColors.grey),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
