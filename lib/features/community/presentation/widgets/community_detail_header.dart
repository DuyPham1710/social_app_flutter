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
  final VoidCallback? onManage;

  const CommunityDetailHeader({
    super.key,
    required this.community,
    required this.memberStatus,
    this.userRole,
    this.onJoin,
    this.onLeave,
    this.onCancelRequest,
    this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    final roleLabel = userRole == 'admin' ? 'Quản trị viên' : 'Thành viên';
    final roleColor = userRole == 'admin'
        ? const Color(0xFFB54708)
        : const Color(0xFF0F766E);
    final isPrivate = (community.status ?? '').toLowerCase() == 'private';
    final privacyLabel = isPrivate ? 'Nhóm riêng tư' : 'Nhóm công khai';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFFE4E6EB),
                  backgroundImage: community.avatar != null
                      ? NetworkImage(community.avatar!)
                      : null,
                  child: community.avatar == null
                      ? const Icon(
                          Icons.groups,
                          size: 30,
                          color: Color(0xFF65676B),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1C1E21),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        '$privacyLabel · ${community.memberCount ?? 0} thành viên',
                        style: const TextStyle(
                          color: Color(0xFF65676B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _InfoChip(
                            icon: isPrivate
                                ? Icons.lock_rounded
                                : Icons.public_rounded,
                            label: privacyLabel,
                          ),
                          if (userRole != null)
                            _InfoChip(
                              icon: userRole == 'admin'
                                  ? Icons.workspace_premium_rounded
                                  : Icons.verified_user_outlined,
                              label: roleLabel,
                              backgroundColor: roleColor.withValues(
                                alpha: 0.14,
                              ),
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

            if (community.description != null &&
                community.description!.isNotEmpty)
              Text(
                community.description!,
                style: TextStyle(
                  color: const Color(0xFF1C1E21),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.35,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Cộng đồng này chưa có mô tả.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFE4E6EB)),
            const SizedBox(height: 14),

            if (memberStatus == 'none')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onJoin,
                  icon: const Icon(
                    Icons.group_add_rounded,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Tham gia cộng đồng',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFCCD0D5)),
                        foregroundColor: const Color(0xFF1C1E21),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                      onPressed: userRole == 'admin' ? onManage : onLeave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userRole == 'admin'
                            ? const Color(0xFFE7F3FF)
                            : const Color(0xFFFFE4E6),
                        elevation: 0,
                        foregroundColor: userRole == 'admin'
                            ? const Color(0xFF1877F2)
                            : const Color(0xFFB91C1C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(
                        userRole == 'admin'
                            ? Icons.tune_rounded
                            : Icons.logout_rounded,
                      ),
                      label: Text(
                        userRole == 'admin' ? 'Quản lý' : 'Rời nhóm',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              )
            else if (memberStatus == 'invited')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
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
        color: backgroundColor ?? const Color(0xFFF0F2F5),
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
