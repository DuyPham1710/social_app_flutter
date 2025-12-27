import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ModalGender extends StatelessWidget {
  const ModalGender({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        "Chọn giới tính",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        ),
      ),

      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Male");
          },
          child: Text(
            "Nam",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Female");
          },
          child: Text(
            "Nữ",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, "Other");
          },
          child: Text(
            "Khác",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
          ),
        ),
      ],

      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
        child: Text(
          "Hủy",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            color: AppColors.primary,
          ),
        ),
      ),
    );
    // return SafeArea(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(20.r),
    //         topRight: Radius.circular(20.r),
    //       ),
    //     ),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         SizedBox(height: 14.h),

    //         Container(
    //           width: 40.w,
    //           height: 4.h,
    //           decoration: BoxDecoration(
    //             color: Colors.grey[400],
    //             borderRadius: BorderRadius.circular(10.r),
    //           ),
    //         ),

    //         SizedBox(height: 10.h),

    //         Text(
    //           'Select Gender',
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
    //         ),

    //         SizedBox(height: 14.h),
    //         Divider(height: 1.h, color: Colors.grey[300]),

    //         ListTile(
    //           title: const Text("Male"),
    //           onTap: () => Navigator.pop(context, "Male"),
    //         ),
    //         Divider(height: 1.h, color: Colors.grey[300]),
    //         ListTile(
    //           title: const Text("Female"),
    //           onTap: () => Navigator.pop(context, "Female"),
    //         ),
    //         Divider(height: 1.h, color: Colors.grey[300]),
    //         ListTile(
    //           title: const Text("Other"),
    //           onTap: () => Navigator.pop(context, "Other"),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
