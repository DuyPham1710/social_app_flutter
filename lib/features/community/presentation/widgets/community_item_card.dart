import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_detail_page.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityItem extends StatefulWidget {
  final dynamic community;

  const CommunityItem({super.key, required this.community});

  @override
  State<CommunityItem> createState() => _CommunityItemState();
}

class _CommunityItemState extends State<CommunityItem> {
  // Local state for optimistic UI updates
  late String? _memberStatus;
  late String? _myRole;

  @override
  void initState() {
    super.initState();
    _memberStatus = widget.community.memberStatus;
    _myRole = widget.community.myRole;
  }

  @override
  void didUpdateWidget(CommunityItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync local state with widget data when it updates
    _memberStatus = widget.community.memberStatus;
    _myRole = widget.community.myRole;
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = _resolveImageUrl(widget.community.avatar as String?);
    final description = (widget.community.description as String?) ?? '';
    final isPrivate =
        ((widget.community.status ?? 'public').toString() == 'private');

    return BlocListener<CommunityDetailBloc, CommunityDetailState>(
      listenWhen: (previous, current) {
        // Only listen to events relevant to this community item
        if (current is CommunityActionSuccess) {
          // Filter by community ID to prevent other items from responding
          return current.communityId == widget.community.id;
        }
        if (current is CommunityDetailError) {
          // Filter error by community ID too
          return current.communityId == widget.community.id;
        }
        if (current is CommunityDetailLoaded &&
            widget.community.id == current.community.id) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is CommunityActionSuccess &&
            state.communityId == widget.community.id) {
          final message = localizedCommunityMessage(
            context.l10n,
            state.message,
          );
          // Update local status based on action message
          if (_memberStatus == null &&
              message == context.l10n.communityJoinRequestSent) {
            // Just joined
            setState(() => _memberStatus = 'pending');
          } else if (_memberStatus == 'pending' &&
              message == context.l10n.communityCancelRequestSuccess) {
            // Cancelled join request
            setState(() => _memberStatus = null);
          }
          showSuccessSnackBar(context, message);
        } else if (state is CommunityDetailError &&
            state.communityId == widget.community.id) {
          showErrorSnackBar(
            context,
            localizedCommunityMessage(context.l10n, state.message),
          );
        } else if (state is CommunityDetailLoaded &&
            widget.community.id == state.community.id) {
          // Sync status when detail loads
          setState(() {
            _memberStatus = state.memberStatus;
            _myRole = state.userRole;
          });
        }
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(
              context,
            ).push(CommunityDetailPage.route(communityId: widget.community.id));
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with type badge
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.08,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.secondBackground,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl == null
                              ? Icon(
                                  Icons.groups_rounded,
                                  color: AppColors.primary,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        top: -4,
                        left: -4,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.divider,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            isPrivate
                                ? Icons.lock_rounded
                                : Icons.public_rounded,
                            size: 12,
                            color: isPrivate
                                ? AppColors.textSecondary
                                : const Color(0xFF0F766E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              widget.community.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (_myRole == 'admin')
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  context.l10n.communityAdmin,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people_outline_rounded,
                                        size: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        context.l10n.communityMembersCount(
                                          widget.community.memberCount ?? 0,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildActionButton(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    // Sử dụng local state (cho optimistic updates) hoặc data từ widget
    final memberStatus = _memberStatus;
    final myRole = _myRole;

    final buttonStyle = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    );
    final tonalStyle = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      foregroundColor: AppColors.primary,
      elevation: 0,
    );
    final outlineStyle = OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      foregroundColor: AppColors.textSecondary,
      side: BorderSide(color: AppColors.divider, width: 0.8),
      backgroundColor: AppColors.secondBackground,
    );

    // Đã tham gia (memberStatus == 'member' hoặc myRole != null)
    if (memberStatus == 'member' || myRole != null) {
      return FilledButton.tonal(
        style: tonalStyle,
        onPressed: () {
          Navigator.of(
            context,
          ).push(CommunityDetailPage.route(communityId: widget.community.id));
        },
        child: Text(context.l10n.commonDetails),
      );
    }

    // Đang chờ duyệt (memberStatus == 'pending')
    if (memberStatus == 'pending') {
      return OutlinedButton(
        style: outlineStyle,
        onPressed: () {
          context.read<CommunityDetailBloc>().add(
            CancelJoinRequestRequested(widget.community.id),
          );
        },
        child: Text(context.l10n.friendCancelRequest),
      );
    }

    // Chưa tham gia (memberStatus == null hoặc không tồn tại)
    return FilledButton(
      style: buttonStyle,
      onPressed: () {
        // Gửi request join
        context.read<CommunityDetailBloc>().add(
          JoinCommunityRequested(widget.community.id),
        );
      },
      child: Text(context.l10n.communityJoinShort),
    );
  }

  String? _resolveImageUrl(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    return null;
  }
}
