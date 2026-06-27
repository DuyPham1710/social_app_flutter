import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class ProfileSkeletonShimmer extends StatelessWidget {
  final Widget child;

  const ProfileSkeletonShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }
}

class ProfileActionSkeleton extends StatelessWidget {
  const ProfileActionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.rs(context),
        vertical: 10.rsh(context),
      ),
      child: ProfileSkeletonShimmer(
        child: Row(
          children: const [
            Expanded(child: ProfileSkeletonBox(height: 38, radius: 8)),
            SizedBox(width: 10),
            Expanded(child: ProfileSkeletonBox(height: 38, radius: 8)),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoSkeleton extends StatelessWidget {
  const ProfileInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        16.rsh(context),
        16.rs(context),
        14.rsh(context),
      ),
      child: ProfileSkeletonShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProfileSkeletonBox(width: 92, height: 20, radius: 10),
            SizedBox(height: 14),
            _ProfileInfoLine(width: 210),
            SizedBox(height: 12),
            _ProfileInfoLine(width: 168),
            SizedBox(height: 12),
            _ProfileInfoLine(width: 190),
          ],
        ),
      ),
    );
  }
}

class ProfileFriendsSkeleton extends StatelessWidget {
  const ProfileFriendsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 8.rsh(context),
        horizontal: 12.rs(context),
      ),
      padding: EdgeInsets.all(12.rs(context)),
      decoration: _skeletonCardDecoration(context),
      child: ProfileSkeletonShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileSkeletonBox(width: 96, height: 20, radius: 10),
                ProfileSkeletonBox(width: 64, height: 18, radius: 9),
              ],
            ),
            SizedBox(height: 8.rsh(context)),
            const ProfileSkeletonBox(width: 84, height: 13, radius: 7),
            SizedBox(height: 12.rsh(context)),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return const _FriendCardSkeleton();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCreatePostSkeleton extends StatelessWidget {
  const ProfileCreatePostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5.rs(context),
        vertical: 8.rsh(context),
      ),
      child: ProfileSkeletonShimmer(
        child: Row(
          children: const [
            ProfileSkeletonBox(width: 44, height: 44, radius: 22),
            SizedBox(width: 10),
            Expanded(child: ProfileSkeletonBox(height: 42, radius: 24)),
            SizedBox(width: 8),
            ProfileSkeletonBox(width: 40, height: 40, radius: 20),
          ],
        ),
      ),
    );
  }
}

class ProfilePostSkeletonList extends StatelessWidget {
  final int itemCount;

  const ProfilePostSkeletonList({super.key, this.itemCount = 2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 8.rsh(context),
      ),
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Container(
            margin: EdgeInsets.only(bottom: 12.rsh(context)),
            padding: EdgeInsets.symmetric(vertical: 8.rsh(context)),
            decoration: _skeletonCardDecoration(context),
            child: ProfileSkeletonShimmer(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rs(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        ProfileSkeletonBox(width: 42, height: 42, radius: 21),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileSkeletonBox(
                                width: 150,
                                height: 14,
                                radius: 7,
                              ),
                              SizedBox(height: 8),
                              ProfileSkeletonBox(
                                width: 90,
                                height: 12,
                                radius: 6,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.rsh(context)),
                    const ProfileSkeletonBox(
                      width: double.infinity,
                      height: 13,
                      radius: 7,
                    ),
                    SizedBox(height: 8.rsh(context)),
                    const ProfileSkeletonBox(width: 230, height: 13, radius: 7),
                    SizedBox(height: 14.rsh(context)),
                    ProfileSkeletonBox(
                      width: double.infinity,
                      height: 180.rsh(context),
                      radius: 12.rsr(context),
                    ),
                    SizedBox(height: 12.rsh(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        ProfileSkeletonBox(width: 64, height: 28, radius: 14),
                        ProfileSkeletonBox(width: 64, height: 28, radius: 14),
                        ProfileSkeletonBox(width: 64, height: 28, radius: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileSkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const ProfileSkeletonBox({
    super.key,
    this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ProfileInfoLine extends StatelessWidget {
  final double width;

  const _ProfileInfoLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProfileSkeletonBox(width: 22, height: 22, radius: 11),
        SizedBox(width: 10.rs(context)),
        ProfileSkeletonBox(width: width, height: 14, radius: 7),
      ],
    );
  }
}

class _FriendCardSkeleton extends StatelessWidget {
  const _FriendCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(12.rsr(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.rsr(context)),
              ),
              child: Container(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.rs(context)),
            child: const ProfileSkeletonBox(width: 72, height: 13, radius: 7),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _skeletonCardDecoration(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(12.rsr(context)),
    border: Border.all(color: AppColors.divider.withValues(alpha: 0.65)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.05),
        blurRadius: 10,
        offset: Offset(0, 3.rsh(context)),
      ),
    ],
  );
}
