import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
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
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/features/community/presentation/pages/edit_community_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityDetailPage extends StatefulWidget {
  final String communityId;
  static Duration fadeTransitionDuration = Duration(milliseconds: 280);

  CommunityDetailPage({super.key, required this.communityId});

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

  static Duration _pageFadeDuration =
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

    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          clipBehavior: Clip.antiAlias,
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(context)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: BlocProvider.value(
              value: context.read<CommunityAdminBloc>(),
              child: Padding(
                padding: EdgeInsets.all(16.rs(context)),
                child: CommunityMembersWidget(
                  communityId: widget.communityId,
                  refreshSeed: _refreshSeed,
                  isInBottomSheet: true,
                  userRole: currentRole,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.background,
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
  }

  void _showInviteFriendsBottomSheet(BuildContext context) {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          clipBehavior: Clip.antiAlias,
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(context)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: InviteFriendsBottomSheet(communityId: widget.communityId),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.background,
        builder: (context) =>
            InviteFriendsBottomSheet(communityId: widget.communityId),
      );
    }
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
      PopupMenuItem<String>(
        value: 'view_members',
        child: Text(
          context.l10n.communityMembers,
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
    );

    // Invite friends (only for members)
    if (isMember) {
      items.add(
        PopupMenuItem<String>(
          value: 'invite_friends',
          child: Text(
            context.l10n.communityInviteFriends,
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }

    // Review members (admin only)
    if (state.userRole == 'admin') {
      items.add(
        PopupMenuItem<String>(
          value: 'review_members',
          child: Text(
            context.l10n.communityReviewMembers,
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );

      items.add(
        PopupMenuItem<String>(
          value: 'review_posts',
          child: Text(
            context.l10n.communityReviewPosts,
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );

      items.add(PopupMenuDivider(height: 8.rsh(context)));

      items.add(
        PopupMenuItem<String>(
          value: 'edit_community',
          child: Text(
            context.l10n.communityEditGroup,
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );

      items.add(
        PopupMenuItem<String>(
          value: 'delete_community',
          child: Text(
            context.l10n.communityDeleteGroup,
            style: TextStyle(color: Color(0xFFB91C1C)),
          ),
        ),
      );
    }

    // Leave community (for members)
    if (isMember && state.userRole != 'admin') {
      items.add(PopupMenuDivider(height: 8.rsh(context)));
      items.add(
        PopupMenuItem<String>(
          value: 'leave_community',
          child: Text(context.l10n.communityLeaveGroup),
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
        title: Text(
          context.l10n.communityDeleteTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          context.l10n.communityDeleteConfirm,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              context.l10n.commonCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CommunityDetailBloc>().add(
                DeleteCommunityRequested(widget.communityId),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Color(0xFFB91C1C)),
            child: Text(
              context.l10n.commonDelete,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPendingMembersReview(BuildContext context) {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          clipBehavior: Clip.antiAlias,
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(context)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: BlocProvider.value(
              value: context.read<CommunityAdminBloc>(),
              child: _buildMembersReviewSheet(context),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.background,
        builder: (_) => BlocProvider.value(
          value: context.read<CommunityAdminBloc>(),
          child: _buildMembersReviewSheet(context),
        ),
      );
    }
  }

  void _showPendingPostsReview(BuildContext context) {
    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (dialogContext) => Dialog(
          clipBehavior: Clip.antiAlias,
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(context)),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: BlocProvider.value(
              value: context.read<CommunityAdminBloc>(),
              child: _buildPostsReviewSheet(context),
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: AppColors.background,
        builder: (_) => BlocProvider.value(
          value: context.read<CommunityAdminBloc>(),
          child: _buildPostsReviewSheet(context),
        ),
      );
    }
  }

  Widget _buildMembersReviewSheet(BuildContext context) {
    return BlocConsumer<CommunityAdminBloc, CommunityAdminState>(
      listener: (context, state) {
        if (state is CommunityAdminActionSuccess) {
          showSuccessSnackBar(
            context,
            localizedCommunityMessage(context.l10n, state.message),
          );
        } else if (state is CommunityAdminError) {
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
            content = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.group_add_rounded,
                    size: 46.rsp(context),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 12.rsh(context)),
                  Text(
                    context.l10n.communityNoPendingRequests,
                    style: TextStyle(
                      fontSize: 15.rsp(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          } else {
            content = ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16.rs(context),
                6.rsh(context),
                16.rs(context),
                20.rsh(context),
              ),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.rsh(context)),
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return _buildReviewMemberCard(context, request);
              },
            );
          }
        } else if (state is CommunityAdminLoading) {
          content = Center(child: CircularProgressIndicator());
        } else {
          content = Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Column(
            children: [
              _buildReviewSheetHeader(
                icon: Icons.how_to_reg_rounded,
                title: context.l10n.communityReviewMembers,
                subtitle: context.l10n.communityReviewMembersSubtitle,
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
          showSuccessSnackBar(
            context,
            localizedCommunityMessage(context.l10n, state.message),
          );
        } else if (state is CommunityAdminError) {
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
            content = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 46.rsp(context),
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 12.rsh(context)),
                  Text(
                    context.l10n.communityNoPendingReviewPosts,
                    style: TextStyle(
                      fontSize: 15.rsp(context),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          } else {
            content = ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16.rs(context),
                6.rsh(context),
                16.rs(context),
                20.rsh(context),
              ),
              itemCount: state.posts.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return _buildReviewPostCard(context, post);
              },
            );
          }
        } else if (state is CommunityAdminLoading) {
          content = Center(child: CircularProgressIndicator());
        } else {
          content = Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Column(
            children: [
              _buildReviewSheetHeader(
                icon: Icons.fact_check_rounded,
                title: context.l10n.communityReviewPosts,
                subtitle: context.l10n.communityReviewPostsSubtitle,
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
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        8.rsh(context),
        16.rs(context),
        12.rsh(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.rs(context),
            height: 42.rsh(context),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(12.rsr(context)),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(width: 10.rs(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.rsp(context),
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.rsp(context),
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

  Widget _buildReviewMemberCard(
    BuildContext context,
    CommunityRequestModel request,
  ) {
    return Container(
      padding: EdgeInsets.all(12.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.rsr(context)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.rsr(context),
                backgroundColor: AppColors.secondBackground,
                backgroundImage: request.user.avatarUrl != null
                    ? NetworkImage(request.user.avatarUrl!)
                    : null,
                child: request.user.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.textSecondary)
                    : null,
              ),
              SizedBox(width: 10.rs(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.user.fullName ?? context.l10n.commonUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.rsp(context),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.rsh(context)),
                    Text(
                      _formatTimeAgo(request.createdAt),
                      style: TextStyle(
                        fontSize: 12.rsp(context),
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rsh(context)),
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
                  icon: Icon(Icons.close_rounded),
                  label: Text(context.l10n.friendReject),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFB91C1C),
                    side: BorderSide(color: Color(0xFFFCA5A5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rsr(context)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.rs(context)),
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
                  icon: Icon(Icons.check_rounded),
                  label: Text(context.l10n.friendAccept),
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rsr(context)),
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
      padding: EdgeInsets.all(12.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14.rsr(context)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.rsr(context),
                backgroundColor: AppColors.secondBackground,
                backgroundImage: post.user.avatarUrl != null
                    ? NetworkImage(post.user.avatarUrl!)
                    : null,
                child: post.user.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.textSecondary)
                    : null,
              ),
              SizedBox(width: 10.rs(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.fullName ?? context.l10n.commonUser,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.rsp(context),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.rsh(context)),
                    Text(
                      _formatTimeAgo(post.createdAt),
                      style: TextStyle(
                        fontSize: 12.rsp(context),
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rsh(context)),
          Text(
            caption.isNotEmpty ? caption : context.l10n.communityPostNoText,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.rsp(context),
              height: 1.35.rsh(context),
              color: caption.isNotEmpty
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hasImage) ...[
            SizedBox(height: 10.rsh(context)),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.rsr(context)),
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
                      size: 26.rsp(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: 12.rsh(context)),
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
                  icon: Icon(Icons.close_rounded),
                  label: Text(context.l10n.friendReject),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFFB91C1C),
                    side: BorderSide(color: Color(0xFFFCA5A5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rsr(context)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.rs(context)),
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
                  icon: Icon(Icons.check_rounded),
                  label: Text(context.l10n.notificationApprovePostAction),
                  style: FilledButton.styleFrom(
                    backgroundColor: Color(0xFF16A34A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.rsr(context)),
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
        title: Text(context.l10n.communityLeaveGroup),
        content: Text(context.l10n.communityLeaveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<CommunityDetailBloc>().add(
                LeaveCommunityRequested(widget.communityId),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Color(0xFFB91C1C)),
            child: Text(context.l10n.communityLeaveGroup),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime? value) {
    if (value == null) return context.l10n.postUnknownTime;

    final now = DateTime.now();
    final date = value.toLocal();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return context.l10n.postJustNow;
    if (diff.inMinutes < 60) return context.l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return context.l10n.timeHoursAgo(diff.inHours);
    if (diff.inDays < 7) return context.l10n.timeDaysAgo(diff.inDays);

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
    return ColoredBox(
      color: AppColors.secondBackground,
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            title: Container(
              width: 150.rs(context),
              height: 16.rsh(context),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(999.rsr(context)),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              color: AppColors.iconPrimary,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            expandedHeight: 240,
            pinned: true,
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.iconPrimary,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.textSecondary.withValues(alpha: 0.08),
                      AppColors.textSecondary.withValues(alpha: 0.16),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 72.rs(context),
                    height: 72.rsh(context),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.rs(context)),
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
              padding: EdgeInsets.fromLTRB(
                16.rs(context),
                16.rsh(context),
                16.rs(context),
                24.rsh(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLoadingCard(height: 118.rsh(context)),
                  SizedBox(height: 12.rsh(context)),
                  _buildLoadingCard(height: 92.rsh(context), compact: true),
                  SizedBox(height: 12.rsh(context)),
                  _buildLoadingCard(height: 210.rsh(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard({required double height, bool compact = false}) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.rsr(context)),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.rs(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLoadingLine(width: 170.rs(context)),
            SizedBox(height: 10.rsh(context)),
            _buildLoadingLine(width: double.infinity),
            if (!compact) ...[
              SizedBox(height: 8.rsh(context)),
              _buildLoadingLine(width: 230.rs(context)),
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
        height: 14.rsh(context),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(999.rsr(context)),
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
      child: Container(
        color: AppColors.background,

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveHelper.feedMaxWidth,
            ),
            child: Scaffold(
              backgroundColor: AppColors.secondBackground,
              body: BlocConsumer<CommunityDetailBloc, CommunityDetailState>(
                listener: (context, state) {
                  if (state is CommunityActionSuccess) {
                    final message = localizedCommunityMessage(
                      context.l10n,
                      state.message,
                    );
                    showSuccessSnackBar(context, message);
                    if (message == context.l10n.communityDeleteSuccess) {
                      Future.delayed(Duration(milliseconds: 300), () {
                        if (mounted) Navigator.of(context).pop(true);
                      });
                    } else {
                      _refreshContent(context);
                    }
                  } else if (state is CommunityDetailError) {
                    showErrorSnackBar(
                      context,
                      localizedCommunityMessage(context.l10n, state.message),
                    );
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
                              size: 42.rsp(context),
                            ),
                            SizedBox(height: 10.rsh(context)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.rs(context),
                              ),
                              child: Text(
                                localizedCommunityMessage(
                                  context.l10n,
                                  state.message,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                            SizedBox(height: 16.rsh(context)),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<CommunityDetailBloc>().add(
                                    CommunityDetailFetched(widget.communityId),
                                  ),
                              child: Text(context.l10n.commonRetry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is CommunityDetailLoaded) {
                    final isMember =
                        state.memberStatus == 'member' ||
                        state.userRole == 'admin';

                    return _fadePage(
                      'loaded-${state.community.id}',
                      RefreshIndicator(
                        onRefresh: () async => _refreshContent(context),
                        child: CustomScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverAppBar(
                              titleSpacing: 0,
                              title: Text(
                                state.community.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              leading: IconButton(
                                icon: Icon(Icons.arrow_back_rounded),
                                color: AppColors.iconPrimary,
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                              ),
                              actions: [
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.more_horiz_rounded),
                                  iconSize: 24.rsp(context),
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
                              backgroundColor: AppColors.background,
                              foregroundColor: AppColors.iconPrimary,
                              surfaceTintColor: Colors.transparent,
                              scrolledUnderElevation: 0,
                              flexibleSpace: FlexibleSpaceBar(
                                background:
                                    (state.community.coverImage?.isNotEmpty ??
                                        false)
                                    ? Image.network(
                                        state.community.coverImage!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color:
                                                    AppColors.secondBackground,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color:
                                                        AppColors.textSecondary,
                                                    size: 36.rsp(context),
                                                  ),
                                                ),
                                              );
                                            },
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xFF3A3B3C),
                                              Color(0xFF242526),
                                            ],
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.groups_rounded,
                                            size: 52.rsp(context),
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
                                  SizedBox(height: 8.rsh(context)),
                                  CommunityDetailHeader(
                                    community: state.community,
                                    memberStatus: state.memberStatus,
                                    userRole: state.userRole,
                                    onJoin: () =>
                                        context.read<CommunityDetailBloc>().add(
                                          JoinCommunityRequested(
                                            widget.communityId,
                                          ),
                                        ),
                                    onCancelRequest: () =>
                                        context.read<CommunityDetailBloc>().add(
                                          CancelJoinRequestRequested(
                                            widget.communityId,
                                          ),
                                        ),
                                    onLeave: () =>
                                        _showLeaveConfirmation(context),
                                    onManage: null,
                                  ),
                                  SizedBox(height: 8.rsh(context)),
                                  if (isMember)
                                    CommunityCreatePostWidget(
                                      avatarUrl: state.community.avatar,
                                      onCreatePost: () => _openCreatePost(
                                        context,
                                        state.userRole,
                                      ),
                                    ),
                                  SizedBox(height: 8.rsh(context)),
                                  CommunityPostsWidget(
                                    communityId: widget.communityId,
                                    refreshSeed: _refreshSeed,
                                    canViewPosts: isMember,
                                    userRole: state.userRole,
                                  ),
                                  SizedBox(height: 22.rsh(context)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _fadePage('empty', Center(child: Text('')));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
