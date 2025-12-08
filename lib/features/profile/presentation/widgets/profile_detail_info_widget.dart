import 'package:flutter/material.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/detail_item.dart';

class ProfileDetailInfoWidget extends StatelessWidget {
  final UserEntity? user;

  const ProfileDetailInfoWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Học vấn
        if (user?.school != null && user?.school!.isNotEmpty)
          DetailItem(
            icon: Icons.school_outlined,
            text: "Đã học tại ${user?.school}",
          ),
        
        // Nơi sống
        if (user?.currentCity != null && user?.currentCity!.isNotEmpty)
          DetailItem(
            icon: Icons.home_outlined,
            text: "Sống tại ${user?.currentCity}",
          ),

        // Quê quán
        if (user?.hometown != null && user?.hometown!.isNotEmpty)
          DetailItem(
            icon: Icons.location_on_outlined,
            text: "Đến từ ${user?.hometown}",
          ),

        // Nơi làm việc
        if (user?.workplace != null && user?.workplace!.isNotEmpty)
           DetailItem(
            icon: Icons.work_outline,
            text: "Làm việc tại ${user?.workplace}",
          )
        else
          // Hiển thị trạng thái chưa có (nếu muốn giống FB hiển thị mờ)
          const DetailItem(
            icon: Icons.work_outline,
            text: "Thêm nơi làm việc",
            isDisabled: true,
          ),

        // Mối quan hệ
        if (user?.relationshipStatus != null && user?.relationshipStatus!.isNotEmpty)
           DetailItem(
            icon: Icons.favorite_outline,
            text: user?.relationshipStatus!,
          )
        else
          const DetailItem(
            icon: Icons.favorite_outline,
            text: "Thêm tình trạng mối quan hệ",
            isDisabled: true,
          ),
      ],
    );
  }
}