import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/data/models/community_invite_model.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

enum _InviteResponseStatus { pending, approved, rejected }

class MyInvitesItem extends StatefulWidget {
  final CommunityInviteModel invite;

  const MyInvitesItem({super.key, required this.invite});

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
            if (state.message.contains('chấp nhận')) {
              setState(() {
                _status = _InviteResponseStatus.approved;
                _isLoading = false;
              });
              showSuccessSnackBar(context, 'Đã chấp nhận lời mời');
            } else if (state.message.contains('từ chối')) {
              setState(() {
                _status = _InviteResponseStatus.rejected;
                _isLoading = false;
              });
              showSuccessSnackBar(context, 'Đã từ chối lời mời');
            }
          }
        } else if (state is CommunityDetailError) {
          setState(() => _isLoading = false);
          showErrorSnackBar(context, state.message);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5EAF0), width: 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0D101828),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
                      radius: 28,
                      backgroundColor: const Color(0xFFF3F4F6),
                      backgroundImage: avatarUrl.isNotEmpty
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl.isEmpty
                          ? const Icon(Icons.group, size: 28, color: Color(0xFF9CA3AF))
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mail_outline,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        communityName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF101828),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getStatusMessage(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _getStatusColor(),
                          fontSize: 13,
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
            const SizedBox(height: 12),
            if (_status == _InviteResponseStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _onApprovePressed(communityId),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline,
                                    size: 16, color: Colors.white),
                                SizedBox(width: 6),
                                Text(
                                  'Chấp nhận',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _onRejectPressed(communityId),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: const BorderSide(
                            color: Color(0xFFD0D5DD), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF667085),
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.close, size: 16, color: Color(0xFF667085)),
                                SizedBox(width: 6),
                                Text(
                                  'Từ chối',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF667085),
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
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: _status == _InviteResponseStatus.approved
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFEECEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _status == _InviteResponseStatus.approved
                        ? const Color(0xFFA6F4C5)
                        : const Color(0xFFFECDCA),
                    width: 1.5,
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
                        size: 16,
                        color: _status == _InviteResponseStatus.approved
                            ? const Color(0xFF059669)
                            : const Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _status == _InviteResponseStatus.approved
                            ? 'Đã chấp nhận'
                            : 'Đã từ chối',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _status == _InviteResponseStatus.approved
                              ? const Color(0xFF059669)
                              : const Color(0xFFDC2626),
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

  String _getStatusMessage() {
    switch (_status) {
      case _InviteResponseStatus.pending:
        return 'Bạn được mời tham gia cộng đồng';
      case _InviteResponseStatus.approved:
        return 'Bạn đã chấp nhận lời mời';
      case _InviteResponseStatus.rejected:
        return 'Bạn đã từ chối lời mời';
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case _InviteResponseStatus.pending:
        return const Color(0xFF667085);
      case _InviteResponseStatus.approved:
        return const Color(0xFF059669);
      case _InviteResponseStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }
}
