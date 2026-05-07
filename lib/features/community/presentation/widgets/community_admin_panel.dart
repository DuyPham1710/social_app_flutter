import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
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
          color: const Color(0xFFF3F8FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFD4E5FF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A1E40AF),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shield_rounded, color: Color(0xFF1D4ED8)),
                SizedBox(width: 8),
                Text(
                  'Bảng quản trị',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Duyệt thành viên mới và kiểm duyệt bài viết trước khi hiển thị.',
              style: TextStyle(
                color: Color(0xFF334155),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFE4EEFF),
                      foregroundColor: const Color(0xFF1E40AF),
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
                    label: const Text('Duyệt thành viên'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1D4ED8),
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
                    label: const Text('Duyệt bài viết'),
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
      backgroundColor: const Color(0xFFF8FAFF),
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
              showSuccessSnackBar(context, state.message);
            } else if (state is CommunityAdminError) {
              if (mounted) {
                setState(() {
                  _processingRequestIds.clear();
                });
              }
              showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            Widget content;

            if (state is PendingRequestsLoaded) {
              if (state.requests.isEmpty) {
                content = _buildEmptyState(
                  icon: Icons.group_add_rounded,
                  message: 'Không có yêu cầu tham gia đang chờ duyệt',
                  hint: 'Khi có thành viên mới gửi yêu cầu, bạn sẽ thấy ở đây.',
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
                message: state.message,
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
                    title: 'Duyệt thành viên',
                    subtitle: 'Xác nhận yêu cầu tham gia cộng đồng',
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
      backgroundColor: const Color(0xFFF8FAFF),
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
              showSuccessSnackBar(context, state.message);
            } else if (state is CommunityAdminError) {
              if (mounted) {
                setState(() {
                  _processingPostIds.clear();
                });
              }
              showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            Widget content;

            if (state is PendingPostsLoaded) {
              if (state.posts.isEmpty) {
                content = _buildEmptyState(
                  icon: Icons.fact_check_outlined,
                  message: 'Không có bài viết nào đang chờ duyệt',
                  hint: 'Bài viết mới sẽ hiển thị tại đây để bạn kiểm duyệt.',
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
                message: state.message,
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
                    title: 'Duyệt bài viết',
                    subtitle: 'Kiểm tra nội dung trước khi bài được công khai',
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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF1D4ED8)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE5E7EB),
                backgroundImage: request.user.avatarUrl != null
                    ? NetworkImage(request.user.avatarUrl!)
                    : null,
                child: request.user.avatarUrl == null
                    ? const Icon(Icons.person, color: Color(0xFF6B7280))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.user.fullName ?? 'Người dùng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimeAgo(request.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(
                icon: Icons.pending_actions_rounded,
                label: 'Đang chờ',
                foreground: const Color(0xFF7C3AED),
                background: const Color(0xFFF3E8FF),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Yêu cầu tham gia cộng đồng đang chờ bạn xét duyệt.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
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
                  label: const Text('Từ chối'),
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
                  label: const Text('Chấp nhận'),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE5E7EB),
                backgroundImage: post.user.avatarUrl != null
                    ? NetworkImage(post.user.avatarUrl!)
                    : null,
                child: post.user.avatarUrl == null
                    ? const Icon(Icons.person, color: Color(0xFF6B7280))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.fullName ?? 'Người dùng',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimeAgo(post.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusChip(
                icon: Icons.article_outlined,
                label: '${post.urls.length} media',
                foreground: const Color(0xFF1D4ED8),
                background: const Color(0xFFE8F1FF),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            caption.isNotEmpty
                ? caption
                : 'Bài viết không có nội dung văn bản.',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              height: 1.35,
              color: caption.isNotEmpty
                  ? const Color(0xFF111827)
                  : const Color(0xFF6B7280),
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
                    color: const Color(0xFFF3F4F6),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.broken_image_rounded,
                      color: Color(0xFF9CA3AF),
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
                  label: const Text('Từ chối'),
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
                  label: const Text('Duyệt bài'),
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
            Icon(icon, size: 46, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
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
              label: const Text('Tải lại'),
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

  String _formatTimeAgo(DateTime? value) {
    if (value == null) {
      return 'Không rõ thời gian';
    }

    final now = DateTime.now();
    final date = value.toLocal();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'Vừa xong';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }
}
