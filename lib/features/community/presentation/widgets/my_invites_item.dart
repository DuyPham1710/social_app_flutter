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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5EAF0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101828),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl.isEmpty ? const Icon(Icons.group) : null,
            ),
            const SizedBox(width: 12),
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
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getStatusMessage(),
                    style: TextStyle(
                      color: _getStatusColor(),
                      fontSize: 12,
                      fontWeight: _status != _InviteResponseStatus.pending
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_status == _InviteResponseStatus.pending)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _onApprovePressed(communityId),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              backgroundColor: AppColors.primary,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Chấp nhận',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () => _onRejectPressed(communityId),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: const BorderSide(color: Color(0xFFD0D5DD)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF667085),
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Từ chối',
                                    style: TextStyle(fontSize: 12),
                                  ),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _status == _InviteResponseStatus.approved
                            ? const Color(0xFFECFDF5)
                            : const Color(0xFFFEECEB),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _status == _InviteResponseStatus.approved
                              ? const Color(0xFFA6F4C5)
                              : const Color(0xFFFECDCA),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _status == _InviteResponseStatus.approved
                              ? '✓ Đã chấp nhận'
                              : '✕ Đã từ chối',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _status == _InviteResponseStatus.approved
                                ? const Color(0xFF059669)
                                : const Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ),
                ],
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
