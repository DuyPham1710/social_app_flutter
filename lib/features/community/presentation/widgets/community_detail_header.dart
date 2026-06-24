import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityDetailHeader extends StatelessWidget {
  final CommunityModel community;
  final String memberStatus;
  final String? userRole;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onCancelRequest;
  final VoidCallback? onManage;

  CommunityDetailHeader({
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
    final roleLabel = userRole == 'admin'
        ? context.l10n.communityAdmin
        : context.l10n.communityMember;
    final roleColor = userRole == 'admin'
        ? Color(0xFFB54708)
        : Color(0xFF0F766E);
    final isPrivate = (community.status ?? '').toLowerCase() == 'private';
    final privacyLabel = isPrivate
        ? context.l10n.communityPrivateGroup
        : context.l10n.communityPublicGroup;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12.rs(context),
        0,
        12.rs(context),
        8.rsh(context),
      ),
      child: Container(
        padding: EdgeInsets.all(16.rs(context)),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14.rsr(context)),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.08),
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
                  radius: 30.rsr(context),
                  backgroundColor: AppColors.secondBackground,
                  backgroundImage: community.avatar != null
                      ? NetworkImage(community.avatar!)
                      : null,
                  child: community.avatar == null
                      ? Icon(
                          Icons.groups,
                          size: 30.rsp(context),
                          color: AppColors.textSecondary,
                        )
                      : null,
                ),
                SizedBox(width: 12.rs(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 22.rsp(context),
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.1.rsh(context),
                        ),
                      ),
                      SizedBox(height: 7.rsh(context)),
                      Text(
                        context.l10n.communityPrivacyMembers(
                          privacyLabel,
                          community.memberCount,
                        ),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.rsp(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.rsh(context)),
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
            SizedBox(height: 14.rsh(context)),

            if (community.description != null &&
                community.description!.isNotEmpty)
              Text(
                community.description!,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.rsp(context),
                  fontWeight: FontWeight.w500,
                  height: 1.35.rsh(context),
                ),
              )
            else
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.rs(context),
                  vertical: 10.rsh(context),
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondBackground,
                  borderRadius: BorderRadius.circular(10.rsr(context)),
                ),
                child: Text(
                  context.l10n.communityNoDescription,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),

            SizedBox(height: 14.rsh(context)),
            Divider(height: 1, color: AppColors.divider),
            SizedBox(height: 14.rsh(context)),

            if (memberStatus == 'none')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onJoin,
                  icon: Icon(Icons.group_add_rounded, color: Colors.white),
                  label: Text(
                    context.l10n.communityJoin,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 13.rsh(context)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rsr(context)),
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
                      icon: Icon(Icons.cancel_outlined),
                      label: Text(context.l10n.friendCancelRequest),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 12.rsh(context),
                        ),
                        side: BorderSide(color: AppColors.divider),
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.rsr(context)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.rs(context)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13.rsh(context)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12.rsr(context)),
                        border: Border.all(color: Color(0xFFFDE68A)),
                      ),
                      child: Text(
                        context.l10n.communityPendingApproval,
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
              if (userRole != 'admin')
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onLeave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFE4E6),
                          elevation: 0,
                          foregroundColor: Color(0xFFB91C1C),
                          padding: EdgeInsets.symmetric(
                            vertical: 12.rsh(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              10.rsr(context),
                            ),
                          ),
                        ),
                        icon: Icon(Icons.logout_rounded),
                        label: Text(
                          context.l10n.communityLeaveGroup,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                )
              else if (memberStatus == 'invited')
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.rs(context),
                    vertical: 12.rsh(context),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12.rsr(context)),
                    border: Border.all(color: Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    context.l10n.communityInvitePendingNotice,
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
    final chipTextColor = textColor ?? AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10.rs(context),
        vertical: 6.rsh(context),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.secondBackground,
        borderRadius: BorderRadius.circular(999.rsr(context)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.rsp(context), color: chipTextColor),
          SizedBox(width: 5.rs(context)),
          Text(
            label,
            style: TextStyle(
              color: chipTextColor,
              fontSize: 12.rsp(context),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
