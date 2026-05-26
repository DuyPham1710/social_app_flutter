import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class CommunityAdminPanel extends StatefulWidget {
  final String communityId;

  const CommunityAdminPanel({super.key, required this.communityId});

  @override
  State<CommunityAdminPanel> createState() => _CommunityAdminPanelState();
}

class _CommunityAdminPanelState extends State<CommunityAdminPanel> {
  final Set<String> _processingRequestIds = <String>{};
  final Set<String> _processingPostIds = <String>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.textSecondary.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_rounded, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  context.l10n.communityAdminPanelTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.communityAdminPanelSubtitle,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.12,
                      ),
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<CommunityAdminBloc>().add(
                        GetPendingRequestsRequested(widget.communityId),
                      );
                      _showPendingRequests(context);
                    },
                    icon: const Icon(Icons.how_to_reg_rounded),
                    label: Text(context.l10n.communityReviewMembers),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      context.read<CommunityAdminBloc>().add(
                        GetPendingPostsRequested(
                          communityId: widget.communityId,
                          page: 1,
                          limit: 10,
                        ),
                      );
                      _showPendingPosts(context);
                    },
                    icon: const Icon(Icons.fact_check_rounded),
                    label: Text(context.l10n.communityReviewPosts),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPendingRequests(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: BlocConsumer<CommunityAdminBloc, CommunityAdminState>(
          listener: (context, state) {
            if (state is CommunityAdminActionSuccess) {
              if (mounted) {
                setState(() {
                  _processingRequestIds.clear();
                });
              }
              showSuccessSnackBar(
                context,
                localizedCommunityMessage(context.l10n, state.message),
              );
            } else if (state is CommunityAdminError) {
              if (mounted) {
                setState(() {
                  _processingRequestIds.clear();
                });
              }
              showErrorSnackBar(
                context,
                localizedCommunityMessage(context.l10n, state.message),
              );
            }
          },
          builder: (context, state) {
            Widget content;

            if (state is PendingRequestsLoaded) {
              if (state.requests.isEmpty) {
                content = _buildEmptyState(
                  icon: Icons.group_add_rounded,
                  message: context.l10n.communityNoPendingRequests,
                  hint: context.l10n.communityPendingRequestsHint,
                );
              } else {
                content = ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                  itemCount: state.requests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final request = state.requests[index];
                    return _buildRequestCard(context, request);
                  },
                );
              }
            } else if (state is CommunityAdminLoading ||
                state is CommunityAdminActionSuccess ||
                state is CommunityAdminInitial) {
              content = const Center(child: CircularProgressIndicator());
            } else if (state is CommunityAdminError) {
              content = _buildErrorState(
                message: localizedCommunityMessage(context.l10n, state.message),
                onRetry: () {
                  context.read<CommunityAdminBloc>().add(
                    GetPendingRequestsRequested(widget.communityId),
                  );
                },
              );
            } else {
              content = const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: Column(
                children: [
                  _buildSheetHeader(
                    icon: Icons.how_to_reg_rounded,
                    title: context.l10n.communityReviewMembers,
                    subtitle: context.l10n.communityReviewMembersSubtitle,
                  ),
                  Expanded(child: content),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPendingPosts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: BlocConsumer<CommunityAdminBloc, CommunityAdminState>(
          listener: (context, state) {
            if (state is CommunityAdminActionSuccess) {
              if (mounted) {
                setState(() {
                  _processingPostIds.clear();
                });
              }
              showSuccessSnackBar(
                context,
                localizedCommunityMessage(context.l10n, state.message),
              );
            } else if (state is CommunityAdminError) {
              if (mounted) {
                setState(() {
                  _processingPostIds.clear();
                });
              }
              showErrorSnackBar(
                context,
                localizedCommunityMessage(context.l10n, state.message),
              );
            }
          },
          builder: (context, state) {
            Widget content;

            if (state is PendingPostsLoaded) {
              if (state.posts.isEmpty) {
                content = _buildEmptyState(
                  icon: Icons.fact_check_outlined,
                  message: context.l10n.communityNoPendingReviewPosts,
                  hint: context.l10n.communityPendingPostsHint,
                );
              } else {
                content = ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
                  itemCount: state.posts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    return _buildPostCard(context, post);
                  },
                );
              }
            } else if (state is CommunityAdminLoading) {
              content = const Center(child: CircularProgressIndicator());
            } else if (state is CommunityAdminActionSuccess) {
              content = const Center(child: CircularProgressIndicator());
            } else if (state is CommunityAdminError) {
              content = _buildErrorState(
                message: localizedCommunityMessage(context.l10n, state.message),
                onRetry: () {
                  context.read<CommunityAdminBloc>().add(
                    GetPendingPostsRequested(
                      communityId: widget.communityId,
                      page: 1,
                      limit: 10,
                    ),
                  );
                },
              );
            } else {
              content = const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: Column(
                children: [
                  _buildSheetHeader(
                    icon: Icons.fact_check_rounded,
                    title: context.l10n.communityReviewPosts,
                    subtitle: context.l10n.communityReviewPostsSubtitle,
                  ),
                  Expanded(child: content),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSheetHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    CommunityRequestModel request,
  ) {
    final isProcessing = _processingRequestIds.contains(request.id);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.secondBackground,
                backgroundImage: request.user.avatarUrl != null
                    ? NetworkImage(request.user.avatarUrl!)
                    : null,
                child: request.user.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.textSecondary)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.user.fullName ?? context.l10n.commonUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      localizedCommunityTimeAgo(
                        context.l10n,
                        request.createdAt,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(
                icon: Icons.pending_actions_rounded,
                label: context.l10n.communityPendingApproval,
                foreground: const Color(0xFF7C3AED),
                background: const Color(0xFFF3E8FF),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.communityJoinRequestPendingMessage,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () => _respondToRequest(
                          context,
                          requestId: request.id,
                          action: 'reject',
                        ),
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.close_rounded),
                  label: Text(context.l10n.friendReject),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB91C1C),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () => _respondToRequest(
                          context,
                          requestId: request.id,
                          action: 'approve',
                        ),
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(context.l10n.friendAccept),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, CommunityPostModel post) {
    final isProcessing = _processingPostIds.contains(post.id);
    final caption = (post.caption ?? '').trim();
    final hasImage = post.urls.isNotEmpty && post.urls.first.url.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.secondBackground,
                backgroundImage: post.user.avatarUrl != null
                    ? NetworkImage(post.user.avatarUrl!)
                    : null,
                child: post.user.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.textSecondary)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.fullName ?? context.l10n.commonUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      localizedCommunityTimeAgo(context.l10n, post.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(
                icon: Icons.article_outlined,
                label: context.l10n.communityMediaCount(post.urls.length),
                foreground: const Color(0xFF1D4ED8),
                background: const Color(0xFFE8F1FF),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            caption.isNotEmpty ? caption : context.l10n.communityPostNoText,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: caption.isNotEmpty
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasImage) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.urls.first.url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.secondBackground,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: AppColors.textSecondary,
                      size: 26,
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () => _respondToPost(
                          context,
                          postId: post.id,
                          action: 'reject',
                        ),
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.close_rounded),
                  label: Text(context.l10n.friendReject),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFB91C1C),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: isProcessing
                      ? null
                      : () => _respondToPost(
                          context,
                          postId: post.id,
                          action: 'approve',
                        ),
                  icon: isProcessing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_rounded),
                  label: Text(context.l10n.notificationApprovePostAction),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required IconData icon,
    required String label,
    required Color foreground,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: foreground,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String hint,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 46,
              color: AppColors.textSecondary.withValues(alpha: 0.75),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.red[300], size: 48),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFB91C1C),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.commonRefresh),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _respondToRequest(
    BuildContext context, {
    required String requestId,
    required String action,
  }) async {
    setState(() {
      _processingRequestIds.add(requestId);
    });
    context.read<CommunityAdminBloc>().add(
      RespondToJoinRequestRequested(
        communityId: widget.communityId,
        requestId: requestId,
        action: action,
      ),
    );
  }

  Future<void> _respondToPost(
    BuildContext context, {
    required String postId,
    required String action,
  }) async {
    setState(() {
      _processingPostIds.add(postId);
    });
    context.read<CommunityAdminBloc>().add(
      ApproveCommunityPostRequested(
        communityId: widget.communityId,
        postId: postId,
        action: action,
      ),
    );
  }
}
