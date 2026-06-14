import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/pages/image_viewer_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isLoading;

  const ProfileHeader({super.key, this.user, this.isLoading = false});

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
                  height: 200.rsh(context),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.rsr(context)),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 16,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  left: 16,
                  child: Container(
                    width: 128.rsr(context),
                    height: 128.rsr(context),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 65.rsh(context)),
            Center(
              child: Container(
                height: 22.rsh(context),
                width: 150.rs(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 8.rsh(context)),
            Center(
              child: Container(
                height: 14.rsh(context),
                width: 210.rs(context),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            SizedBox(height: 10.rsh(context)),
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
                  CupertinoPageRoute(
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
                height: 200.rsh(context),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.rsr(context)),
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
                  color: AppColors.secondBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 20,
                  color: AppColors.iconPrimary,
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
                        CupertinoPageRoute(
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
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.secondBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: AppColors.iconPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 65.rsh(context)),

        // User name
        Center(
          child: Text(
            user?.fullName ?? context.l10n.profileUserNameFallback,
            style: TextStyle(
              fontSize: 22.rsp(context),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 6.rsh(context)),

        // Bio
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.rs(context)),
          child: Text(
            user?.bio?.isNotEmpty == true
                ? user!.bio!
                : context.l10n.profileNoBio,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.rsp(context),
            ),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 10.rsh(context)),
      ],
    );
  }
}
