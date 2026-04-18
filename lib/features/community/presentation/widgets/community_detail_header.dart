import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';

class CommunityDetailHeader extends StatelessWidget {
  final CommunityModel community;
  final String memberStatus;
  final String? userRole;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onCancelRequest;
  final VoidCallback? onCreatePost;
  final VoidCallback? onManage;

  const CommunityDetailHeader({
    super.key,
    required this.community,
    required this.memberStatus,
    this.userRole,
    this.onJoin,
    this.onLeave,
    this.onCancelRequest,
    this.onCreatePost,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final roleLabel = userRole == 'admin' ? 'Quản trị viên' : 'Thành viên';
    final roleColor = userRole == 'admin'
        ? const Color(0xFFB54708)
        : const Color(0xFF0F766E);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE4E7EC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140F172A),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFFEEF2FF),
                  backgroundImage: community.avatar != null
                      ? NetworkImage(community.avatar!)
                      : null,
                  child: community.avatar == null
                      ? const Icon(Icons.groups, size: 32)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _InfoChip(
                            icon: Icons.group_outlined,
                            label: '${community.memberCount} thành viên',
                          ),
                          if (userRole != null)
                            _InfoChip(
                              icon: userRole == 'admin'
                                  ? Icons.workspace_premium_rounded
                                  : Icons.verified_user_outlined,
                              label: roleLabel,
                              backgroundColor: roleColor.withValues(alpha: 0.14),
                              textColor: roleColor,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            if (community.description != null && community.description!.isNotEmpty)
              Text(
                community.description!,
                style: TextStyle(
                  color: Colors.grey[800],
                  height: 1.35,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  'Cộng đồng này chưa có mô tả.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

            const SizedBox(height: 16),

            if (memberStatus == 'none')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onJoin,
                  icon: const Icon(Icons.group_add_rounded, color: Colors.white),
                  label: const Text(
                    'Tham gia cộng đồng',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              )
            else if (memberStatus == 'pending')
              Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onCancelRequest,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('Hủy yêu cầu'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: const BorderSide(color: Color(0xFF98A2B3)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: const Text(
                          'Đang chờ duyệt',
                          style: TextStyle(
                            color: Color(0xFFB45309),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                
              )
            else if (memberStatus == 'member' || userRole == 'admin')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onCreatePost,
                      icon: const Icon(Icons.edit_square, color: Colors.white),
                      label: const Text(
                        'Đăng bài',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: userRole == 'admin' ? onManage : onLeave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            userRole == 'admin' ? const Color(0xFF1D4ED8) : Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        userRole == 'admin' ? Icons.tune_rounded : Icons.logout_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        userRole == 'admin' ? 'Quản lý' : 'Rời nhóm',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else if (memberStatus == 'invited')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: const Text(
                  'Bạn đang có lời mời tham gia. Hãy phản hồi trong tab Lời mời.',
                  style: TextStyle(
                    color: Color(0xFF3730A3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipTextColor = textColor ?? const Color(0xFF475467);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipTextColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: chipTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
