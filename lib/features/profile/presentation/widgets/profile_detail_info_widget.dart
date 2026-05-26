import 'package:flutter/material.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/utils/profile_localization.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/detail_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ProfileDetailInfoWidget extends StatelessWidget {
  final UserEntity? user;

  const ProfileDetailInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        // Học vấn
        if (user?.school != null && user!.school!.isNotEmpty)
          DetailItem(
            icon: Icons.school_outlined,
            text: l10n.profileStudiedAt(user!.school!),
          ),

        // Nơi sống
        if (user?.currentCity != null && user!.currentCity!.isNotEmpty)
          DetailItem(
            icon: Icons.home,
            text: l10n.profileLivesIn(user!.currentCity!),
          ),

        // Quê quán
        if (user?.hometown != null && user!.hometown!.isNotEmpty)
          DetailItem(
            icon: Icons.location_city,
            text: l10n.profileFrom(user!.hometown!),
          ),

        // Nơi làm việc
        if (user?.workplace != null && user!.workplace!.isNotEmpty)
          DetailItem(
            icon: Icons.work,
            text: l10n.profileWorksAt(user!.workplace!),
          )
        else
          // Hiển thị trạng thái chưa có (nếu muốn giống FB hiển thị mờ)
          DetailItem(
            icon: Icons.work,
            text: l10n.profileAddWorkplace,
            isDisabled: true,
          ),

        // Mối quan hệ
        if (user?.relationshipStatus != null &&
            user!.relationshipStatus!.isNotEmpty)
          DetailItem(
            icon: Icons.favorite,
            text: localizedRelationshipStatus(l10n, user!.relationshipStatus),
          )
        else
          DetailItem(
            icon: Icons.favorite,
            text: l10n.profileAddRelationshipStatus,
            isDisabled: true,
          ),
      ],
    );
  }
}
