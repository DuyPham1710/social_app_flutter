import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/data/models/community_invite_model.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

enum _InviteResponseStatus { pending, approved, rejected }

class MyInvitesItem extends StatefulWidget {
  final CommunityInviteModel invite;

  MyInvitesItem({super.key, required this.invite});

  @override
  State<MyInvitesItem> createState() => _MyInvitesItemState();
}

class _MyInvitesItemState extends State<MyInvitesItem> {
  _InviteResponseStatus _status = _InviteResponseStatus.pending;
  bool _isLoading = false;

  void _onApprovePressed(String communityId) {
    if (_status != _InviteResponseStatus.pending) return;

    setState(() => _isLoading = true);
    debugPrint(
      'Approve button pressed - communityId: $communityId, requestId: ${widget.invite.id}',
    );

    context.read<CommunityDetailBloc>().add(
      RespondToInviteRequested(
        communityId: communityId,
        requestId: widget.invite.id,
        action: 'approve',
      ),
    );
  }

  void _onRejectPressed(String communityId) {
    if (_status != _InviteResponseStatus.pending) return;

    setState(() => _isLoading = true);
    debugPrint(
      'Reject button pressed - communityId: $communityId, requestId: ${widget.invite.id}',
    );

    context.read<CommunityDetailBloc>().add(
      RespondToInviteRequested(
        communityId: communityId,
        requestId: widget.invite.id,
        action: 'reject',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract community info from nested object
    final community = widget.invite.communityId;
    final communityId = community.id;
    final communityName = community.name;
    final communityAvatar = community.avatar;
    final avatarUrl = communityAvatar ?? '';

    debugPrint(
      'MyInvitesItem - communityId: $communityId, name: $communityName, avatar: $avatarUrl, requestId: ${widget.invite.id}',
    );

    return BlocListener<CommunityDetailBloc, CommunityDetailState>(
      listener: (context, state) {
        if (state is CommunityActionSuccess) {
          // Only update this item if the requestId matches
          if (state.requestId != null && state.requestId == widget.invite.id) {
            final message = localizedCommunityMessage(
              context.l10n,
              state.message,
            );
            if (message == context.l10n.notificationInviteAccepted) {
              setState(() {
                _status = _InviteResponseStatus.approved;
                _isLoading = false;
              });
              showSuccessSnackBar(
                context,
                context.l10n.notificationInviteAccepted,
              );
            } else if (message == context.l10n.notificationInviteRejected) {
              setState(() {
                _status = _InviteResponseStatus.rejected;
                _isLoading = false;
              });
              showSuccessSnackBar(
                context,
                context.l10n.notificationInviteRejected,
              );
            }
          }
        } else if (state is CommunityDetailError) {
          setState(() => _isLoading = false);
          showErrorSnackBar(
            context,
            localizedCommunityMessage(context.l10n, state.message),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.rs(context),
          vertical: 12.rsh(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16.rsr(context)),
          border: Border.all(color: AppColors.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28.rsr(context),
                      backgroundColor: AppColors.secondBackground,
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl.isEmpty
                          ? Icon(
                              Icons.group,
                              size: 28.rsp(context),
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24.rs(context),
                        height: 24.rsh(context),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 2.rs(context),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: 12.rsp(context),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 14.rs(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        communityName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.rsp(context),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6.rsh(context)),
                      Text(
                        _getStatusMessage(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 13.rsp(context),
                          fontWeight: _status != _InviteResponseStatus.pending
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.rsh(context)),
            if (_status == _InviteResponseStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _onApprovePressed(communityId),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 11.rsh(context),
                        ),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.rsr(context)),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 18.rsh(context),
                              width: 18.rs(context),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16.rsp(context),
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6.rs(context)),
                                Text(
                                  context.l10n.friendAccept,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  SizedBox(width: 10.rs(context)),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _onRejectPressed(communityId),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 11.rsh(context),
                        ),
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide(
                          color: AppColors.divider,
                          width: 1.5.rs(context),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.rsr(context)),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 18.rsh(context),
                              width: 18.rs(context),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.textSecondary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 16.rsp(context),
                                  color: AppColors.textSecondary,
                                ),
                                SizedBox(width: 6.rs(context)),
                                Text(
                                  context.l10n.friendReject,
                                  style: TextStyle(
                                    fontSize: 13.rsp(context),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 11.rsh(context)),
                decoration: BoxDecoration(
                  color: _status == _InviteResponseStatus.approved
                      ? Color(0xFFECFDF5)
                      : Color(0xFFFEECEB),
                  borderRadius: BorderRadius.circular(10.rsr(context)),
                  border: Border.all(
                    color: _status == _InviteResponseStatus.approved
                        ? Color(0xFFA6F4C5)
                        : Color(0xFFFECDCA),
                    width: 1.5.rs(context),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _status == _InviteResponseStatus.approved
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 16.rsp(context),
                        color: _status == _InviteResponseStatus.approved
                            ? Color(0xFF059669)
                            : Color(0xFFDC2626),
                      ),
                      SizedBox(width: 6.rs(context)),
                      Text(
                        _status == _InviteResponseStatus.approved
                            ? context.l10n.notificationInviteAccepted
                            : context.l10n.notificationInviteRejected,
                        style: TextStyle(
                          fontSize: 13.rsp(context),
                          fontWeight: FontWeight.w600,
                          color: _status == _InviteResponseStatus.approved
                              ? Color(0xFF059669)
                              : Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getStatusMessage(BuildContext context) {
    switch (_status) {
      case _InviteResponseStatus.pending:
        return context.l10n.communityInviteStatusPending;
      case _InviteResponseStatus.approved:
        return context.l10n.communityInviteStatusApproved;
      case _InviteResponseStatus.rejected:
        return context.l10n.communityInviteStatusRejected;
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case _InviteResponseStatus.pending:
        return AppColors.textSecondary;
      case _InviteResponseStatus.approved:
        return Color(0xFF059669);
      case _InviteResponseStatus.rejected:
        return Color(0xFFDC2626);
    }
  }
}
