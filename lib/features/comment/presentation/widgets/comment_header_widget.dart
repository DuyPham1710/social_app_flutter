import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class CommentHeaderWidget extends StatelessWidget {
  const CommentHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: const [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                      "https://i.pinimg.com/1200x/39/44/6c/39446caa52f53369b92bc97253d2b2f1.jpg",
                    ),
                  ),
                  Positioned(
                    left: 18,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        "https://www.citypng.com/public/uploads/preview/haha-facebook-messenger-react-face-like-emoji-701751695136164me5ogbbpnk.png",
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 20.w),

              Text(
                '1000',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          TextButton(
            onPressed: () {},
            child: Text(
              '28 lượt chia sẻ',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
