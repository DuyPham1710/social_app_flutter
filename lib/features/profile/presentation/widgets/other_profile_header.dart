import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/pages/image_viewer_page.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class OtherProfileHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isLoading;

  const OtherProfileHeader({super.key, this.user, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ProfileSkeletonShimmer(
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
                  bottom: -60,
                  left: 0,
                  right: 0,
                  child: Center(
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

            // Avatar
            Positioned(
              bottom: -60,
              left: 0,
              right: 0,
              child: Center(
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
        Center(
          child: Padding(
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
        ),

        SizedBox(height: 10.rsh(context)),
      ],
    );
  }
}
