import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';

class OtherProfileActions extends StatelessWidget {
  final RelationshipStatusEntity? relationship;
  final VoidCallback? onSendRequest;
  final VoidCallback? onCancelRequest;
  final VoidCallback? onAcceptRequest;
  final VoidCallback? onRejectRequest;
  final VoidCallback? onUnfriend;
  final VoidCallback? onMessage;

  const OtherProfileActions({
    super.key,
    required this.relationship,
    this.onSendRequest,
    this.onCancelRequest,
    this.onAcceptRequest,
    this.onRejectRequest,
    this.onUnfriend,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (relationship == null) {
      return const SizedBox.shrink();
    }

    final status = relationship!.status;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (relationship!.canSendRequest == true)
            ElevatedButton(
              onPressed: onSendRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Thêm bạn bè', style: TextStyle(color: Colors.white)),
            )
          else if (relationship!.canCancelRequest == true)
            OutlinedButton(
              onPressed: onCancelRequest,
              child: const Text('Hủy yêu cầu kết bạn'),
            )
          else if (relationship!.canAcceptRequest == true)
            ElevatedButton(
              onPressed: onAcceptRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Chấp nhận kết bạn', style: TextStyle(color: Colors.white)),
            )
          else if (status == 'friends') ...[
            OutlinedButton(
              onPressed: onUnfriend,
              child: const Text('Hủy kết bạn'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: onMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Nhắn tin', style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }
}
