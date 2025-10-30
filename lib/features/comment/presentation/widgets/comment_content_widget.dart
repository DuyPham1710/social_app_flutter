import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommentContentWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CommentContentWidget({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 4.w, 16.h),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                  ),
                ),

                SizedBox(width: 10.w),

                // Comment content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comment container
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCommentItem,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'User ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              'This is a comment from user ${index + 1}.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Bottom actions: date, like, reply
                          Padding(
                            padding: EdgeInsets.only(top: 4.h, left: 6.w),
                            child: Row(
                              children: [
                                Text(
                                  '6 ngày',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Thích',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Trả lời',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Reaction badge (bottom right corner)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h, left: 8.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.network(
                                        'https://i.pinimg.com/1200x/39/44/6c/39446caa52f53369b92bc97253d2b2f1.jpg',
                                        width: 12.w,
                                        height: 12.h,
                                      ),
                                      SizedBox(width: 2.w),
                                      Image.network(
                                        'https://www.citypng.com/public/uploads/preview/haha-facebook-messenger-react-face-like-emoji-701751695136164me5ogbbpnk.png',
                                        width: 12.w,
                                        height: 12.h,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '5',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
