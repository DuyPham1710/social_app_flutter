import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/pages/image_viewer_page.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isLoading;

  const ProfileHeader({super.key, this.user, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              // Background cover shimmer
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(height: 50.h),
              // Avatar shimmer
              CircleAvatar(radius: 60.r, backgroundColor: Colors.white),
              SizedBox(height: 16.h),
              // Name shimmer
              Container(height: 20.h, width: 140.w, color: Colors.white),
              SizedBox(height: 8.h),
              // Bio shimmer
              Container(height: 14.h, width: 200.w, color: Colors.white),
            ],
          ),
        ),
      );
    }

    if (user == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          clipBehavior: Clip.none,
          children: [
            // Cover Image
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ImageViewerPage(
                      imageUrl:
                          user?.coverUrl ??
                          'https://res.cloudinary.com/dk7ypst5k/image/upload/v1744336768/samples/balloons.jpg',
                      title: 'Ảnh bìa',
                    ),
                  ),
                );
              },
              child: Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                    image: NetworkImage(
                      user?.coverUrl ??
                          'https://res.cloudinary.com/dk7ypst5k/image/upload/v1744336768/samples/balloons.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Camera icon on cover
            Positioned(
              bottom: 10,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined, size: 20),
              ),
            ),

            // Avatar
            Positioned(
              bottom: -60,
              left: 16,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ImageViewerPage(
                            imageUrl:
                                user?.avatarUrl ??
                                'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                            title: 'Ảnh đại diện',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          user?.avatarUrl ??
                              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 65.h),

        // User name
        Center(
          child: Text(
            user?.fullName ?? 'User Name',
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 6.h),

        // Bio
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            user?.bio?.isNotEmpty == true ? user!.bio! : 'Chưa có tiểu sử',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 10.h),
      ],
    );
  }
}
