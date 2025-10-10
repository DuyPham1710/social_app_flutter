// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:social_app_fe/core/constants/app_colors.dart';

// class StoryItem extends StatelessWidget {
//   const StoryItem({super.key, required this.story});

//   final Story story;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           clipBehavior: Clip.none,
//           alignment: Alignment.bottomCenter,
//           children: [
//             Container(
//               width: 80.w,
//               height: 120.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12.r),
//                 image: DecorationImage(
//                   image: NetworkImage(story.imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             // Badge LIVE
//             Positioned(
//               top: 8,
//               right: 8,
//               child: story.isLive
//                   ? Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 6.w,
//                         vertical: 2.h,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.black87,
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       child: Text(
//                         "LIVE",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//             ),
//             // Avatar dưới chính giữa
//             Positioned(
//               bottom: -18.h,
//               child: CircleAvatar(
//                 radius: 18.r,
//                 backgroundColor: Colors.white,
//                 child: CircleAvatar(
//                   radius: 16.r,
//                   backgroundImage: NetworkImage(story.avatarUrl),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 30.h),
//         Text(
//           story.name,
//           style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
// }
