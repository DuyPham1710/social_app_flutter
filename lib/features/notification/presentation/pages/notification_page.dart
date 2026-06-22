import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';
import 'package:social_app_fe/features/community/domain/usecases/respond_to_invite_usecase.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_detail_page.dart';
import 'package:social_app_fe/features/notification/presentation/pages/community_post_approval_detail_page.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_invite_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_join_approved_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_join_rejected_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_join_request_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_post_approved_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_post_pending_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_post_rejected_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/community_public_join_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/face_tag_suggest_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/notification_loading_page.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/post_loading_page.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/react_post_notification_item.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/react_story_notification_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/post_detail_page.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_post_detail_usecase.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/friend/domain/usecases/accept_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/reject_friend_request_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:social_app_fe/features/community/domain/usecases/respond_to_join_request_usecase.dart';
import '../widgets/comment_notification_item.dart';
import '../widgets/friend_request_notification_item.dart';
import '../services/notification_fcm_service.dart';
import '../widgets/post_report_detail_modal.dart';
import '../widgets/post_report_notification_item.dart';
import '../widgets/face_detected_notification_item.dart';
import '../widgets/tag_notification_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _pageSize = 15;
  double _lastScrollPosition =
      0; // Track last scroll position to detect scroll down

  @override
  void initState() {
    super.initState();
    // Add scroll listener once
    _scrollController.addListener(_onScroll);
    // Set flag that user is on notification page
    NotificationFcmService.setOnNotificationPage(true);
  }

  @override
  void deactivate() {
    // User is leaving notification page
    NotificationFcmService.setOnNotificationPage(false);
    super.deactivate();
  }

  void _onScroll() {
    final currentPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    // Only load more when:
    // 1. Scrolling down (not just rebuilding at same position)
    // 2. Near the bottom (within 100 pixels)
    // 3. Not already loading
    if (currentPosition > _lastScrollPosition && // Scrolling down
        currentPosition >= maxScroll - 100) {
      final state = context.read<NotificationBloc>().state;
      if (state.hasMore && !state.isLoadingMore) {
        _loadNextPage(context);
      }
    }

    _lastScrollPosition = currentPosition;
  }

  void _loadNextPage(BuildContext context) {
    _currentPage += 1;
    context.read<NotificationBloc>().add(
      LoadMoreNotificationsEvent(page: _currentPage, limit: _pageSize),
    );
  }

  String _timeAgo(BuildContext context, DateTime time) {
    final l10n = context.l10n;
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes == 0) return l10n.postJustNow;
    if (diff.inMinutes < 60) return l10n.timeMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.timeHoursAgo(diff.inHours);
    return l10n.timeDaysAgo(diff.inDays);
  }

  void _markAsRead(String notificationId) {
    context.read<NotificationBloc>().add(MarkNotificationRead(notificationId));
  }

  Widget _buildWrappedNotificationItem(dynamic notification) {
    return Stack(
      children: [
        _buildNotificationItem(notification),
        Positioned(
          top: 0,
          right: 0,
          child: PopupMenuButton<String>(
            color: AppColors.background,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onSelected: (value) {
              if (value == 'delete') {
                context.read<NotificationBloc>().add(
                  RemoveNotification(notification.id),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      context.l10n.friendDelete,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
            child: const SizedBox(width: 48, height: 48),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(dynamic notification) {
    switch (notification.type) {
      case NotificationType.FRIEND_REQUEST:
        return FriendRequestNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          mutualFriends: '',
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onAccept: () async {
            _handleAcceptFriendRequest(notification);
          },
          onRemove: () async {
            _handleCancelFriendRequest(notification);
          },
        );

      case NotificationType.POST_COMMENT:
        return CommentNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          content: notification.message,
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          actionText: context.l10n.notificationCommentedOnYourPost,
          onUserTap: () {
            _handleViewerProfileTap(context, notification);
          },
          onMessageTap: () {
            _navigateToCommentInPost(
              postId: notification.content,
              commentId: notification.targetId,
              notificationId: notification.id,
            );
            // _markAsRead(notification.id);
          },
        );

      case NotificationType.COMMENT_REACTION:
        return CommentNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          content: notification.message,
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          actionText: context.l10n.notificationReactedToYourComment,
          onUserTap: () {
            _handleViewerProfileTap(context, notification);
          },
          onMessageTap: () {
            _navigateToCommentInPost(
              postId: notification.content,
              commentId: notification.targetId,
              notificationId: notification.id,
            );
            // _markAsRead(notification.id);
          },
        );
      case NotificationType.UNKNOWN:
        return const SizedBox.shrink();
      case NotificationType.POST_REACTION:
        return ReactPostNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          message: notification.message,
          content: notification.content ?? '',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          postId: notification.targetId,
          actionText: context.l10n.notificationReactedToYourPost,
          onUserTap: () {
            _handleViewerProfileTap(context, notification);
          },
          onMessageTap: () async {
            // _markAsRead(notification.id);
            _handleJumpToPost(notification);
          },
        );
      case NotificationType.STORY_REACTION:
        return ReactStoryNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          message: notification.message,
          content: notification.content ?? '',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          actionText: context.l10n.notificationReactedToYourStory,
          storyId: notification.targetId,
          onUserTap: () {
            _handleViewerProfileTap(context, notification.sender?.userId);
          },
          onMessageTap: () {
            // Currently no action defined for story react message tap
          },
        );
      case NotificationType.POST_REPORT_REVIEWED:
        return PostReportNotificationItem(
          message: notification.message,
          note: notification.content,
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          postId: notification.targetId,
          onTap: () {
            // Hiển thị modal chi tiết lý do ẩn bài viết
            if (notification.targetId != null) {
              _showPostReportDetailModal(notification);
            }
          },
        );
      case NotificationType.FACE_DETECTED:
        return FaceDetectedNotificationItem(
          isRead: notification.isRead,
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          message: notification.message,
          time: _timeAgo(context, notification.createdAt),
          postId: notification.targetId,
          actionText: context.l10n.notificationPostedWithYou,
          onUserTap: () {
            _handleViewerProfileTap(context, notification);
          },
          onMessageTap: () async {
            _handleJumpToPost(notification);
          },
        );
      case NotificationType.TAG_POST:
        return TagNotificationItem(
          isRead: notification.isRead,
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          message: notification.message,
          actionText: context.l10n.notificationTaggedYouInPost,
          time: _timeAgo(context, notification.createdAt),
          postId: notification.targetId,
          onUserTap: () {
            _handleViewerProfileTap(context, notification);
          },
          onMessageTap: () async {
            _handleJumpToPost(notification);
          },
        );
      case NotificationType.FACE_TAG_SUGGEST:
        return FaceTagSuggestNotificationItem(
          message: notification.message,
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          onTap: () {
            List<String> suggestedIds = [];
            if (notification.content != null &&
                notification.content!.isNotEmpty) {
              try {
                suggestedIds = List<String>.from(
                  jsonDecode(notification.content!),
                );
              } catch (e) {
                // Ignore parse error
              }
            }
            _handleJumpToPost(
              notification,
              initialAutoTagUserIds: suggestedIds,
            );
          },
        );

      case NotificationType.COMMUNITY_PUBLIC_JOIN:
        return CommunityPublicJoinNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          communityName: notification.content ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          actionText: context.l10n.notificationCommunityJoined,
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onCommunityTap: () {
            final id = notification.community?.id;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );

      case NotificationType.COMMUNITY_JOIN_REQUEST:
        return CommunityJoinRequestNotificationItem(
          avatarUrl:
              notification.community?.avatar ??
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          communityName:
              notification.community?.name ??
              notification.content ??
              'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          actionText: context.l10n.notificationCommunityJoinRequestSent,
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onAccept: () async {
            _markAsRead(notification.id);
            await _handleAcceptJoinRequest(notification);
          },
          onReject: () async {
            _markAsRead(notification.id);
            await _handleRejectJoinRequest(notification);
          },
          onCommunityTap: () {
            final id = notification.community?.id;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );

      case NotificationType.COMMUNITY_INVITE:
        return CommunityInviteNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          communityName: notification.community?.name ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onAccept: () async {
            _markAsRead(notification.id);
            await _handleAcceptInviteRequest(notification);
          },
          onReject: () async {
            _markAsRead(notification.id);
            await _handleRejectInviteRequest(notification);
          },
          onCommunityTap: () {
            final id = notification.targetId;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );

      case NotificationType.COMMUNITY_JOIN_APPROVED:
        return CommunityJoinApprovedNotificationItem(
          avatarUrl:
              notification.community?.avatar ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          communityName: notification.content ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          actionText: context.l10n.notificationCommunityJoinApprovedByAdmin,
          onCommunityTap: () {
            final id = notification.targetId;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );

      case NotificationType.COMMUNITY_JOIN_REJECTED:
        return CommunityJoinRejectedNotificationItem(
          avatarUrl:
              notification.community?.avatar ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: 'Admin',
          userId: '',
          communityName: notification.content ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          actionText: context.l10n.notificationCommunityJoinRejectedByAdmin,
          onUserTap: () {},
          onCommunityTap: () {
            final id = notification.targetId;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );

      case NotificationType.COMMUNITY_POST_APPROVED:
        return CommunityPostApprovedNotificationItem(
          avatarUrl:
              notification.community?.avatar ??
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          communityName: notification.content ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          actionText: context.l10n.notificationCommunityPostApprovedByAdmin,
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onViewPost: () async {
            final isAdminReview =
                notification.message.contains('cần bạn phê duyệt') ||
                notification.message.contains('phê duyệt');

            _markAsRead(notification.id);

            _handleJumpToPost(notification);
          },
          onCommunityTap: () {
            final id = notification.community?.id;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );

      case NotificationType.COMMUNITY_POST_PENDING:
        return CommunityPostPendingNotificationItem(
          avatarUrl:
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          communityName: notification.content ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          actionText: context.l10n.notificationCommunityPostRequestSent,
          isRead: notification.isRead,
          message: notification.message,
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onViewPost: () async {
            _markAsRead(notification.id);
            final communityId = notification.community?.id;
            final postId = notification.targetId;
            if (communityId != null && postId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityPostApprovalDetailPage(
                    notificationId: notification.id,
                    communityId: communityId,
                    postId: postId,
                    senderName: notification.sender?.fullName ?? '',
                    senderAvatar:
                        notification.sender?.avatarUrl ??
                        'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                    communityName: notification.content ?? 'Community',
                    createdAt: notification.createdAt,
                  ),
                ),
              );
              return;
            }
          },
          onCommunityTap: () {
            final id = notification.community?.id;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
          onReviewTap: () {
            _markAsRead(notification.id);
            final communityId = notification.community?.id;
            final postId = notification.targetId;
            if (communityId != null && postId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommunityPostApprovalDetailPage(
                    notificationId: notification.id,
                    communityId: communityId,
                    postId: postId,
                    senderName: notification.sender?.fullName ?? '',
                    senderAvatar:
                        notification.sender?.avatarUrl ??
                        'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
                    communityName: notification.content ?? 'Community',
                    createdAt: notification.createdAt,
                  ),
                ),
              );
            }
          },
        );

      case NotificationType.COMMUNITY_POST_REJECTED:
        return CommunityPostRejectedNotificationItem(
          avatarUrl:
              notification.community?.avatar ??
              notification.sender?.avatarUrl ??
              'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          communityName: notification.content ?? 'Community',
          time: _timeAgo(context, notification.createdAt),
          isRead: notification.isRead,
          message: notification.message,
          actionText: context.l10n.notificationCommunityPostRejectedByAdmin,
          onUserTap: () {
            if (notification.sender?.userId != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => s1<OtherProfileBloc>()
                      ..add(
                        LoadOtherUserProfileEvent(
                          userId: notification.sender!.userId,
                        ),
                      ),
                    child: OtherProfilePage(
                      userId: notification.sender!.userId,
                    ),
                  ),
                ),
              );
            }
          },
          onViewDetails: () async {
            _markAsRead(notification.id);
            // TODO: Implement view rejection details
          },
          onCommunityTap: () {
            final id = notification.community?.id;
            if (id != null) {
              Navigator.push(
                context,
                CommunityDetailPage.route(communityId: id),
              );
              _markAsRead(notification.id);
            }
          },
        );
      default:
        throw UnimplementedError(
          'Unknown notification type: ${notification.type}',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                context.l10n.notificationTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh, color: AppColors.iconPrimary),
                  onPressed: () {
                    // Trigger reload
                    _currentPage = 1; // Reset page counter
                    context.read<NotificationBloc>().add(ReloadNotifications());
                  },
                  tooltip: context.l10n.notificationRefreshTooltip,
                ),
              ],
            ),
            body: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                print(
                  '[NotificationPage] BlocBuilder rebuilding with ${state.notifications.length} notifications',
                );

                // Show loading page on initial load
                if (state.isInitialLoading) {
                  return const NotificationLoadingPage();
                }

                // Show loading page during reload (regardless of whether there's data)
                if (state.isReloading) {
                  return const NotificationLoadingPage();
                }

                if (state.notifications.isEmpty) {
                  print('[NotificationPage] No notifications to display');
                  return RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: AppColors.background,
                    onRefresh: () async {
                      _currentPage = 1;
                      context.read<NotificationBloc>().add(
                        ReloadNotifications(),
                      );
                      await Future.delayed(const Duration(milliseconds: 800));
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 400,
                          child: Center(
                            child: Text(
                              context.l10n.notificationEmpty,
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildNotificationList(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, NotificationState state) {
    // Separate unread and read notifications
    final unreadNotifications = state.notifications
        .where((n) => !n.isRead)
        .toList();
    final readNotifications = state.notifications
        .where((n) => n.isRead)
        .toList();

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.background,
      onRefresh: () async {
        _currentPage = 1;
        context.read<NotificationBloc>().add(ReloadNotifications());
        await Future.delayed(const Duration(milliseconds: 800));
      },
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // "Mới" section (unread notifications)
          if (unreadNotifications.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                context.l10n.notificationNew,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ...unreadNotifications.map((n) => _buildWrappedNotificationItem(n)),
          ],
          // "Cũ hơn" section (read notifications)
          // Only show title if there are both unread and read notifications
          if (readNotifications.isNotEmpty &&
              unreadNotifications.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                context.l10n.notificationOlder,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
          // Show read notifications (with or without title)
          if (readNotifications.isNotEmpty)
            ...readNotifications.map((n) => _buildWrappedNotificationItem(n)),

          // Loading indicator when loading more
          if (state.isLoadingMore)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),

          // Show "end of data" message when no more pages
          if (!state.hasMore && !state.isLoadingMore) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  context.l10n.notificationEndOfList,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _navigateToCommentInPost({
    required String? postId,
    required String? commentId,
    required String? notificationId,
  }) async {
    print(
      '[Notification] navigateToCommentInPost - postId: $postId, commentId: $commentId, notificationId: $notificationId',
    );

    if (postId == null || postId.isEmpty) {
      print('[Notification] postId is null/empty, returning');
      return;
    }

    // Navigate to loading page with smooth fade animation
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PostLoadingPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );

    // Load post
    GetPostDetailParams params = GetPostDetailParams(postId: postId);
    final result = await s1<GetPostDetailUsecase>()(params: params);
    print('[Notification] Post loaded, result type: ${result.runtimeType}');

    if (context.mounted) {
      if (result is DataStateSuccess && result.data != null) {
        print(
          '[Notification] Post loaded successfully, passing commentId: $commentId to PostDetailPage',
        );
        // Replace loading page with post detail and scroll to comment
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PostDetailPage(post: result.data!, initialCommentId: commentId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        // Post doesn't exist or error loading
        Navigator.of(context).pop(); // Close loading page

        showErrorSnackBar(context, context.l10n.postNotFound);

        // Delete the notification
        try {
          s1<DeleteNotificationUseCase>()(params: notificationId ?? '');
        } catch (_) {}
        context.read<NotificationBloc>().add(
          RemoveNotification(notificationId ?? ''),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    // Ensure flag is reset when page is disposed
    NotificationFcmService.setOnNotificationPage(false);
    super.dispose();
  }

  Future<void> _handleAcceptFriendRequest(notification) async {
    final targetId = notification.targetId;
    if (targetId == null) return;
    context.read<NotificationBloc>().add(RemoveNotification(notification.id));

    final result = await s1<AcceptFriendRequestUseCase>()(targetId);
    if (result is DataStateSuccess) {
      // Update UI immediately by removing from local state
      showSuccessSnackBar(context, context.l10n.friendRequestAccepted);
    } else {
      showErrorSnackBar(context, context.l10n.friendRequestNotFound);
    }

    try {
      s1<DeleteNotificationUseCase>()(params: notification.id);
    } catch (e) {}
  }

  Future<void> _handleCancelFriendRequest(notification) async {
    final targetId = notification.targetId;
    if (targetId == null) return;

    context.read<NotificationBloc>().add(RemoveNotification(notification.id));

    // Then handle server operations
    final result = await s1<RejectFriendRequestUseCase>()(targetId);
    if (result is DataStateSuccess) {
      showSuccessSnackBar(context, context.l10n.friendRequestRejected);
    } else {
      showErrorSnackBar(context, context.l10n.friendRequestNotFound);
    }

    // Delete from server in background
    try {
      s1<DeleteNotificationUseCase>()(params: notification.id);
    } catch (e) {}
  }

  Future<void> _handleAcceptJoinRequest(notification) async {
    final requestId = notification.targetId;
    final communityId = notification.community?.id;

    if (requestId == null ||
        requestId.isEmpty ||
        communityId == null ||
        communityId.isEmpty) {
      showErrorSnackBar(
        context,
        context.l10n.notificationCannotHandleJoinRequest,
      );
      // Delete from server in background
      try {
        s1<DeleteNotificationUseCase>()(params: notification.id);
      } catch (e) {}
      return;
    }

    // Remove from UI immediately
    context.read<NotificationBloc>().add(RemoveNotification(notification.id));

    // Call the API
    final result = await s1<RespondToJoinRequestUseCase>()(
      params: RespondToJoinRequestParams(
        communityId: communityId,
        requestId: requestId,
        action: 'approve',
      ),
    );

    if (result is DataStateSuccess) {
      showSuccessSnackBar(
        context,
        context.l10n.notificationJoinRequestAccepted,
      );
    } else {
      showErrorSnackBar(context, context.l10n.notificationJoinRequestFailed);
    }

    // Delete from server in background
    try {
      s1<DeleteNotificationUseCase>()(params: notification.id);
    } catch (e) {}
  }

  Future<void> _handleRejectJoinRequest(notification) async {
    final requestId = notification.targetId;
    final communityId = notification.community?.id;

    if (requestId == null ||
        requestId.isEmpty ||
        communityId == null ||
        communityId.isEmpty) {
      showErrorSnackBar(
        context,
        context.l10n.notificationCannotHandleJoinRequest,
      );
      try {
        s1<DeleteNotificationUseCase>()(params: notification.id);
      } catch (e) {}
      return;
    }

    // Remove from UI immediately
    context.read<NotificationBloc>().add(RemoveNotification(notification.id));

    // Call the API
    final result = await s1<RespondToJoinRequestUseCase>()(
      params: RespondToJoinRequestParams(
        communityId: communityId,
        requestId: requestId,
        action: 'reject',
      ),
    );

    if (result is DataStateSuccess) {
      showSuccessSnackBar(
        context,
        context.l10n.notificationJoinRequestRejected,
      );
    } else {
      showErrorSnackBar(context, context.l10n.notificationJoinRequestFailed);
    }

    // Delete from server in background
    try {
      s1<DeleteNotificationUseCase>()(params: notification.id);
    } catch (e) {}
  }

  Future<void> _handleAcceptInviteRequest(notification) async {
    final requestId = notification.targetId;
    final communityId = notification.community?.id;

    if (requestId == null ||
        requestId.isEmpty ||
        communityId == null ||
        communityId.isEmpty) {
      showErrorSnackBar(context, context.l10n.notificationCannotHandleInvite);
      // Delete from server in background
      try {
        s1<DeleteNotificationUseCase>()(params: notification.id);
      } catch (e) {}
      return;
    }

    // Remove from UI immediately
    context.read<NotificationBloc>().add(RemoveNotification(notification.id));

    // Call the API
    final result = await s1<RespondToInviteUseCase>()(
      params: RespondToInviteParams(
        communityId: communityId,
        requestId: requestId,
        action: 'approve',
      ),
    );

    if (result is DataStateSuccess) {
      showSuccessSnackBar(context, context.l10n.notificationInviteAccepted);
    } else {
      showErrorSnackBar(context, context.l10n.notificationInviteFailed);
    }

    // Delete from server in background
    try {
      s1<DeleteNotificationUseCase>()(params: notification.id);
    } catch (e) {}
  }

  Future<void> _handleRejectInviteRequest(notification) async {
    final requestId = notification.targetId;
    final communityId = notification.community?.id;

    if (requestId == null ||
        requestId.isEmpty ||
        communityId == null ||
        communityId.isEmpty) {
      showErrorSnackBar(context, context.l10n.notificationCannotHandleInvite);
      try {
        s1<DeleteNotificationUseCase>()(params: notification.id);
      } catch (e) {}
      return;
    }

    // Remove from UI immediately
    context.read<NotificationBloc>().add(RemoveNotification(notification.id));

    // Call the API
    final result = await s1<RespondToInviteUseCase>()(
      params: RespondToInviteParams(
        communityId: communityId,
        requestId: requestId,
        action: 'reject',
      ),
    );

    if (result is DataStateSuccess) {
      showSuccessSnackBar(context, context.l10n.notificationInviteRejected);
    } else {
      showErrorSnackBar(context, context.l10n.notificationInviteFailed);
    }

    // Delete from server in background
    try {
      s1<DeleteNotificationUseCase>()(params: notification.id);
    } catch (e) {}
  }

  void _handleViewerProfileTap(BuildContext context, notification) {
    if (notification.sender?.userId != null) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => s1<OtherProfileBloc>()
              ..add(
                LoadOtherUserProfileEvent(userId: notification.sender!.userId),
              ),
            child: OtherProfilePage(userId: notification.sender!.userId),
          ),
        ),
      );
    }
  }

  Future<void> _handleJumpToPost(
    notification, {
    List<String>? initialAutoTagUserIds,
  }) async {
    final postId = notification.targetId;
    if (postId != null && postId.isNotEmpty) {
      // Navigate to loading page with smooth fade animation
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const PostLoadingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );

      // Load post
      GetPostDetailParams params = GetPostDetailParams(postId: postId);
      final result = await s1<GetPostDetailUsecase>()(params: params);

      if (context.mounted) {
        if (result is DataStateSuccess && result.data != null) {
          // Replace loading page with post detail
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PostDetailPage(
                    post: result.data!,
                    initialAutoTagUserIds: initialAutoTagUserIds,
                  ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        } else {
          // Post doesn't exist or error loading
          Navigator.of(context).pop(); // Close loading page

          showErrorSnackBar(context, context.l10n.postNotFound);

          // Delete the notification
          try {
            s1<DeleteNotificationUseCase>()(params: notification.id);
          } catch (_) {}
          context.read<NotificationBloc>().add(
            RemoveNotification(notification.id),
          );
        }
      }
    }
  }

  void _showPostReportDetailModal(notification) {
    final postId = notification.targetId ?? '';
    final message = notification.message ?? '';
    final note = notification.content;

    // Parse status từ message
    // Message format: "Báo cáo về "[caption]" đã được xác nhận" hoặc "đã bị từ chối"
    String status = 'reviewed'; // default
    if (message.contains('đã bị từ chối')) {
      status = 'rejected';
    } else if (message.contains('đã được xác nhận')) {
      status = 'reviewed';
    }

    // Extract post title từ message
    // Format: "Báo cáo về "[caption]" đã được xác nhận"
    String postTitle = '';
    final startIndex = message.indexOf('"');
    final endIndex = message.lastIndexOf('"');
    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      postTitle = message.substring(startIndex + 1, endIndex);
    } else {
      // Fallback: tìm "bài viết của bạn"
      if (message.contains('bài viết của bạn')) {
        postTitle = context.l10n.postYourPost;
      } else {
        postTitle = context.l10n.postGeneric;
      }
    }

    PostReportDetailModal.show(
      context,
      postId: postId,
      postTitle: postTitle,
      status: status,
      note: note,
    );
  }
}
