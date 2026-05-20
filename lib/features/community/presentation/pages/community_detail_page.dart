import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';
import 'package:social_app_fe/features/community/data/models/community_request_model.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_admin_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_detail_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_create_post_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_detail_header.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_members_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_posts_widget.dart';
import 'package:social_app_fe/features/community/presentation/widgets/invite_friends_bottom_sheet.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_create_post_page.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/features/community/presentation/pages/edit_community_page.dart';

class CommunityDetailPage extends StatefulWidget {
  final String communityId;
  static const Duration fadeTransitionDuration = Duration(milliseconds: 280);

  const CommunityDetailPage({super.key, required this.communityId});

  static Route<void> route({required String communityId}) {
    return PageRouteBuilder<void>(
      transitionDuration: fadeTransitionDuration,
      reverseTransitionDuration: fadeTransitionDuration,
      pageBuilder: (_, __, ___) =>
          CommunityDetailPage(communityId: communityId),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
          child: child,
        );
      },
    );
  }

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  int _refreshSeed = 0;

  static const Color _pageBackground = Color(0xFFF0F2F5);
  static const Duration _pageFadeDuration =
      CommunityDetailPage.fadeTransitionDuration;

  void _refreshContent(BuildContext context) {
    setState(() {
      _refreshSeed++;
    });
    context.read<CommunityDetailBloc>().add(
      CommunityDetailFetched(widget.communityId),
    );
  }

  void _openCreatePost(BuildContext context, String? userRole) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CommunityCreatePostPage(
          communityId: widget.communityId,
          userRole: userRole,
          onPostCreated: () => _refreshContent(context),
        ),
      ),
    );
  }

  void _showMembersBottomSheet(BuildContext context) {
    final state = context.read<CommunityDetailBloc>().state;
    String? currentRole;
    if (state is CommunityDetailLoaded) {
      currentRole = state.userRole;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          builder: (context, scrollController) => Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: CommunityMembersWidget(
                    communityId: widget.communityId,
                    refreshSeed: _refreshSeed,
                    isInBottomSheet: true,
                    userRole: currentRole,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showInviteFriendsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) =>
          InviteFriendsBottomSheet(communityId: widget.communityId),
    );
  }

  List<PopupMenuEntry<String>> _buildMenuItems(
    BuildContext context,
    CommunityDetailLoaded state,
  ) {
    final isMember =
        state.memberStatus == 'member' || state.userRole == 'admin';
    final items = <PopupMenuEntry<String>>[];

    // View members
    items.add(
      const PopupMenuItem<String>(
        value: 'view_members',
        child: Text('Thành viên'),
      ),
    );

    // Invite friends (only for members)
    if (isMember) {
      items.add(
        const PopupMenuItem<String>(
          value: 'invite_friends',
          child: Text('Mời bạn bè'),
        ),
      );
    }

    // Review members (admin only)
    if (state.userRole == 'admin') {
      items.add(
        const PopupMenuItem<String>(
          value: 'review_members',
          child: Text('Duyệt thành viên'),
        ),
      );

      items.add(
        const PopupMenuItem<String>(
          value: 'review_posts',
          child: Text('Duyệt bài viết'),
        ),
      );

      items.add(const PopupMenuDivider(height: 8));

      items.add(
        const PopupMenuItem<String>(
          value: 'edit_community',
          child: Text('Chỉnh sửa nhóm'),
        ),
      );

      items.add(
        const PopupMenuItem<String>(
          value: 'delete_community',
          child: Text('Xóa nhóm', style: TextStyle(color: Color(0xFFB91C1C))),
        ),
      );
    }

    // Leave community (for members)
    if (isMember && state.userRole != 'admin') {
      items.add(const PopupMenuDivider(height: 8));
      items.add(
        const PopupMenuItem<String>(
          value: 'leave_community',
          child: Text('Rời nhóm'),
        ),
      );
    }

    return items;
  }

  void _handleMenuAction(
    BuildContext context,
    String value,
    CommunityDetailLoaded state,
  ) {
    switch (value) {
      case 'view_members':
        _showMembersBottomSheet(context);
      case 'invite_friends':
        _showInviteFriendsBottomSheet(context);
      case 'review_members':
        context.read<CommunityAdminBloc>().add(
          GetPendingRequestsRequested(widget.communityId),
        );
        _showPendingMembersReview(context);
      case 'review_posts':
        context.read<CommunityAdminBloc>().add(
          GetPendingPostsRequested(
            communityId: widget.communityId,
            page: 1,
            limit: 10,
          ),
        );
        _showPendingPostsReview(context);
      case 'edit_community':
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (_) =>
                    EditCommunityPage(initialCommunity: state.community),
              ),
            )
            .then((_) => _refreshContent(context));
      case 'delete_community':
        _showDeleteConfirmation(context);
      case 'leave_community':
        _showLeaveConfirmation(context);
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Xóa cộng đồng'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa cộng đồng này? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CommunityDetailBloc>().add(
                DeleteCommunityRequested(widget.communityId),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showPendingMembersReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8FAFF),
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: _buildMembersReviewSheet(context),
      ),
    );
  }

  void _showPendingPostsReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFF8FAFF),
      builder: (_) => BlocProvider.value(
        value: context.read<CommunityAdminBloc>(),
        child: _buildPostsReviewSheet(context),
      ),
    );
  }

  Widget _buildMembersReviewSheet(BuildContext context) {
    return BlocConsumer<CommunityAdminBloc, CommunityAdminState>(
      listener: (context, state) {
        if (state is CommunityAdminActionSuccess) {
          showSuccessSnackBar(context, state.message);
        } else if (state is CommunityAdminError) {
          showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        Widget content;

        if (state is PendingRequestsLoaded) {
          if (state.requests.isEmpty) {
            content = const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_add_rounded,
                    size: 46,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Không có yêu cầu tham gia đang chờ duyệt',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          } else {
            content = ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return _buildReviewMemberCard(context, request);
              },
            );
          }
        } else if (state is CommunityAdminLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else {
          content = const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Column(
            children: [
              _buildReviewSheetHeader(
                icon: Icons.how_to_reg_rounded,
                title: 'Duyệt thành viên',
                subtitle: 'Xác nhận yêu cầu tham gia cộng đồng',
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostsReviewSheet(BuildContext context) {
    return BlocConsumer<CommunityAdminBloc, CommunityAdminState>(
      listener: (context, state) {
        if (state is CommunityAdminActionSuccess) {
          showSuccessSnackBar(context, state.message);
        } else if (state is CommunityAdminError) {
          showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        Widget content;

        if (state is PendingPostsLoaded) {
          if (state.posts.isEmpty) {
            content = const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 46,
                    color: Color(0xFF94A3B8),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Không có bài viết nào đang chờ duyệt',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          } else {
            content = ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              itemCount: state.posts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return _buildReviewPostCard(context, post);
              },
            );
          }
        } else if (state is CommunityAdminLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else {
          content = const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Column(
            children: [
              _buildReviewSheetHeader(
                icon: Icons.fact_check_rounded,
                title: 'Duyệt bài viết',
                subtitle: 'Kiểm tra nội dung trước khi bài được công khai',
              ),
              Expanded(child: content),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewSheetHeader({
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

  Widget _buildReviewMemberCard(
    BuildContext context,
    CommunityRequestModel request,
  ) {
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
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<CommunityAdminBloc>().add(
                      RespondToJoinRequestRequested(
                        communityId: widget.communityId,
                        requestId: request.id,
                        action: 'reject',
                      ),
                    );
                  },
                  icon: const Icon(Icons.close_rounded),
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
                  onPressed: () {
                    context.read<CommunityAdminBloc>().add(
                      RespondToJoinRequestRequested(
                        communityId: widget.communityId,
                        requestId: request.id,
                        action: 'approve',
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_rounded),
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

  Widget _buildReviewPostCard(BuildContext context, CommunityPostModel post) {
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            caption.isNotEmpty
                ? caption
                : 'Bài viết không có nội dung văn bản.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
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
                  onPressed: () {
                    context.read<CommunityAdminBloc>().add(
                      ApproveCommunityPostRequested(
                        communityId: widget.communityId,
                        postId: post.id,
                        action: 'reject',
                      ),
                    );
                  },
                  icon: const Icon(Icons.close_rounded),
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
                  onPressed: () {
                    context.read<CommunityAdminBloc>().add(
                      ApproveCommunityPostRequested(
                        communityId: widget.communityId,
                        postId: post.id,
                        action: 'approve',
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_rounded),
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

  void _showLeaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Rời nhóm'),
        content: const Text(
          'Bạn có chắc chắn muốn rời khỏi cộng đồng này? Bạn có thể tham gia lại sau nếu muốn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CommunityDetailBloc>().add(
                LeaveCommunityRequested(widget.communityId),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB91C1C),
            ),
            child: const Text('Rời nhóm'),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime? value) {
    if (value == null) return 'Không rõ thời gian';

    final now = DateTime.now();
    final date = value.toLocal();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  Widget _fadePage(String key, Widget child) {
    return AnimatedSwitcher(
      duration: _pageFadeDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
  }

  Widget _buildLoadingPage() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverAppBar(
          titleSpacing: 0,
          title: Container(
            width: 150,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFFE4E7EC),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: const Color(0xFF1C1E21),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          expandedHeight: 240,
          pinned: true,
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1C1E21),
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFE8EEF5), Color(0xFFD8E1EA)],
                ),
              ),
              child: Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLoadingCard(height: 118),
                const SizedBox(height: 12),
                _buildLoadingCard(height: 92, compact: true),
                const SizedBox(height: 12),
                _buildLoadingCard(height: 210),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard({required double height, bool compact = false}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoadingLine(width: 170),
            const SizedBox(height: 10),
            _buildLoadingLine(width: double.infinity),
            if (!compact) ...[
              const SizedBox(height: 8),
              _buildLoadingLine(width: 230),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingLine({required double width}) {
    return FractionallySizedBox(
      widthFactor: width == double.infinity ? 1 : null,
      child: Container(
        width: width == double.infinity ? null : width,
        height: 14,
        decoration: BoxDecoration(
          color: const Color(0xFFE9EEF5),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CommunityDetailBloc>(
          create: (_) =>
              s1<CommunityDetailBloc>()
                ..add(CommunityDetailFetched(widget.communityId)),
        ),
        BlocProvider<CommunityAdminBloc>(
          create: (_) => s1<CommunityAdminBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: _pageBackground,
        body: BlocConsumer<CommunityDetailBloc, CommunityDetailState>(
          listener: (context, state) {
            if (state is CommunityActionSuccess) {
              showSuccessSnackBar(context, state.message);
              if (state.message == 'Đã xóa cộng đồng thành công') {
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) Navigator.of(context).pop(true);
                });
              } else {
                _refreshContent(context);
              }
            } else if (state is CommunityDetailError) {
              showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is CommunityDetailLoading ||
                state is CommunityDetailInitial) {
              return _fadePage('loading', _buildLoadingPage());
            }

            if (state is CommunityDetailError) {
              return _fadePage(
                'error',
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_tethering_error_rounded,
                        color: Colors.red[300],
                        size: 42,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(state.message, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CommunityDetailBloc>()
                            .add(CommunityDetailFetched(widget.communityId)),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is CommunityDetailLoaded) {
              final isMember =
                  state.memberStatus == 'member' || state.userRole == 'admin';

              return _fadePage(
                'loaded-${state.community.id}',
                RefreshIndicator(
                  onRefresh: () async => _refreshContent(context),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        titleSpacing: 0,
                        title: Text(
                          state.community.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF1C1E21),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: const Color(0xFF1C1E21),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        actions: [
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_horiz_rounded),
                            iconSize: 24,
                            color: AppColors.background,
                            onSelected: (value) {
                              _handleMenuAction(context, value, state);
                            },
                            itemBuilder: (BuildContext context) {
                              return _buildMenuItems(context, state);
                            },
                          ),
                        ],
                        expandedHeight: 240,
                        pinned: true,
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1C1E21),
                        surfaceTintColor: Colors.transparent,
                        scrolledUnderElevation: 0,
                        flexibleSpace: FlexibleSpaceBar(
                          background:
                              (state.community.coverImage?.isNotEmpty ?? false)
                              ? Image.network(
                                  state.community.coverImage!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFFBCC0C4),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Color(0xFF65676B),
                                          size: 36,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF3A3B3C),
                                        Color(0xFF242526),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.groups_rounded,
                                      size: 52,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            CommunityDetailHeader(
                              community: state.community,
                              memberStatus: state.memberStatus,
                              userRole: state.userRole,
                              onJoin: () =>
                                  context.read<CommunityDetailBloc>().add(
                                    JoinCommunityRequested(widget.communityId),
                                  ),
                              onCancelRequest: () =>
                                  context.read<CommunityDetailBloc>().add(
                                    CancelJoinRequestRequested(
                                      widget.communityId,
                                    ),
                                  ),
                              onLeave: () =>
                                  context.read<CommunityDetailBloc>().add(
                                    LeaveCommunityRequested(widget.communityId),
                                  ),
                              onManage: null,
                            ),
                            const SizedBox(height: 8),
                            if (isMember)
                              CommunityCreatePostWidget(
                                avatarUrl: state.community.avatar,
                                onCreatePost: () =>
                                    _openCreatePost(context, state.userRole),
                              ),
                            const SizedBox(height: 8),
                            CommunityPostsWidget(
                              communityId: widget.communityId,
                              refreshSeed: _refreshSeed,
                              canViewPosts: isMember,
                              userRole: state.userRole,
                            ),
                            const SizedBox(height: 22),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return _fadePage('empty', const Center(child: Text('')));
          },
        ),
      ),
    );
  }
}
