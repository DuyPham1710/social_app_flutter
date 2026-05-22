import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/utils/profile_localization.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/detail_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ProfileInfo extends StatelessWidget {
  final UserEntity? user;
  ProfileInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Học vấn
          const SizedBox(width: 8),
          Text(
            l10n.profileAbout,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (user != null && user!.school != null && user!.school!.isNotEmpty)
            DetailItem(
              icon: Icons.school,
              text: l10n.profileStudiedAt(user!.school!),
            ),
          // Nơi sống
          if (user != null &&
              user!.currentCity != null &&
              user!.currentCity!.isNotEmpty)
            DetailItem(
              icon: Icons.home,
              text: l10n.profileLivesIn(user!.currentCity!),
            ),

          // Quê quán
          if (user != null &&
              user!.hometown != null &&
              user!.hometown!.isNotEmpty)
            DetailItem(
              icon: Icons.location_city,
              text: l10n.profileFrom(user!.hometown!),
            ),

          // Nơi làm việc
          if (user != null &&
              user!.workplace != null &&
              user!.workplace!.isNotEmpty)
            DetailItem(
              icon: Icons.work,
              text: l10n.profileWorksAt(user!.workplace!),
            ),

          // Mối quan hệ
          if (user != null &&
              user!.relationshipStatus != null &&
              user!.relationshipStatus!.isNotEmpty)
            DetailItem(
              icon: Icons.favorite,
              text: localizedRelationshipStatus(l10n, user!.relationshipStatus),
            ),
        ],
      ),
    );
  }
}
