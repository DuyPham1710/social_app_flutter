import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalGender extends StatelessWidget {
  const ModalGender({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 14.h),

            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            SizedBox(height: 10.h),

            Text(
              'Select Gender',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),

            SizedBox(height: 14.h),
            Divider(height: 1.h, color: Colors.grey[300]),

            ListTile(
              title: const Text("Male"),
              onTap: () => Navigator.pop(context, "Male"),
            ),
            Divider(height: 1.h, color: Colors.grey[300]),
            ListTile(
              title: const Text("Female"),
              onTap: () => Navigator.pop(context, "Female"),
            ),
            Divider(height: 1.h, color: Colors.grey[300]),
            ListTile(
              title: const Text("Other"),
              onTap: () => Navigator.pop(context, "Other"),
            ),
          ],
        ),
      ),
    );
  }
}
