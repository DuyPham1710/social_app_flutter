import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/pages/image_viewer_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class OtherProfileHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isLoading;

  const OtherProfileHeader({super.key, this.user, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Shimmer.fromColors(
        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: 16,
                  child: Container(
                    width: 128.r,
                    height: 128.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 65.h),
            Center(
              child: Container(
                height: 22.h,
                width: 150.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Center(
              child: Container(
                height: 14.h,
                width: 210.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
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
                  MaterialPageRoute(
                    builder: (context) => ImageViewerPage(
                      imageUrl:
                          user?.coverUrl ??
                          'https://res.cloudinary.com/dk7ypst5k/image/upload/v1744336768/samples/balloons.jpg',
                      title: context.l10n.profileCoverPhoto,
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
                        MaterialPageRoute(
                          builder: (context) => ImageViewerPage(
                            imageUrl:
                                user?.avatarUrl ??
                                'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                            title: context.l10n.profileAvatarPhoto,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 4,
                        ),
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
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 65.h),

        // User name
        Center(
          child: Text(
            user?.fullName ?? context.l10n.profileUserNameFallback,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 6.h),

        // Bio
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Text(
            user?.bio?.isNotEmpty == true
                ? user!.bio!
                : context.l10n.profileNoBio,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 10.h),
      ],
    );
  }
}
