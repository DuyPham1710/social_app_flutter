import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';
import 'package:social_app_fe/features/notification/presentation/widgets/react_post_notification_item.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/other_profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/pages/other_profile_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/post_detail_page.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_post_detail_usecase.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/friend/domain/usecases/accept_friend_request_usecase.dart';
import 'package:social_app_fe/features/friend/domain/usecases/reject_friend_request_usecase.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/notification/domain/usecases/delete_notification_usecase.dart';
import '../widgets/comment_notification_item.dart';
import '../widgets/friend_request_notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoadingPage = false;
  final int _pageSize = 10;
  VoidCallback? _scrollListener;
  @override
  void initState() {
    super.initState();
    // scroll listener will be added in build context
  }

  void _onScroll(bool hasMore, bool isLoadingMore, BuildContext context) {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore) {
      _loadNextPage(hasMore, context);
    }
  }

  void _loadNextPage(bool hasMore, BuildContext context) {
    if (!hasMore) {
      // no more data, don't load
      return;
    }

    _currentPage += 1;
    context.read<NotificationBloc>().add(
      LoadMoreNotificationsEvent(page: _currentPage, limit: _pageSize),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    return '${diff.inDays} ngày';
  }

  void _markAsRead(String notificationId) {
    context.read<NotificationBloc>().add(MarkNotificationRead(notificationId));
  }

  Widget _buildNotificationItem(dynamic notification) {
    switch (notification.type) {
      case NotificationType.FRIEND_REQUEST:
        return FriendRequestNotificationItem(
          avatarUrl: notification.sender?.avatarUrl ?? '',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          time: _timeAgo(notification.createdAt),
          isRead: notification.isRead,
          mutualFriends: '',
          onUserTap: () {
            _markAsRead(notification.id);
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
            final targetId = notification.targetId;
            if (targetId == null) return;
            final result = await s1<AcceptFriendRequestUseCase>()(targetId);
            if (result is DataStateSuccess) {
              // also request server to delete notification from DB
              try {
                s1<DeleteNotificationUseCase>()(params: notification.id);
              } catch (_) {}
              context.read<NotificationBloc>().add(
                RemoveNotification(notification.id),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chấp nhận thất bại')),
              );
            }
          },
          onRemove: () async {
            _markAsRead(notification.id);
            final targetId = notification.targetId;
            if (targetId == null) return;
            final result = await s1<RejectFriendRequestUseCase>()(targetId);
            if (result is DataStateSuccess) {
              try {
                s1<DeleteNotificationUseCase>()(params: notification.id);
              } catch (_) {}
              context.read<NotificationBloc>().add(
                RemoveNotification(notification.id),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Xóa thất bại')));
            }
          },
        );

      case NotificationType.POST_COMMENT:
        return CommentNotificationItem(
          avatarUrl: notification.sender?.avatarUrl ?? '',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          content: notification.message,
          time: _timeAgo(notification.createdAt),
          isRead: notification.isRead,
          onUserTap: () {
            _markAsRead(notification.id);
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
          onMessageTap: () {
            _markAsRead(notification.id);
            _navigateToCommentInPost(
              postId: notification.content,
              commentId: notification.targetId,
              notificationId: notification.id,
            );
          },
        );
      case NotificationType.UNKNOWN:
        throw UnimplementedError();
      case NotificationType.POST_REACTION:
        return ReactPostNotificationItem(
          avatarUrl: notification.sender?.avatarUrl ?? '',
          userName: notification.sender?.fullName ?? '',
          userId: notification.sender?.userId ?? '',
          message: notification.message,
          content: notification.content ?? '',
          time: _timeAgo(notification.createdAt),
          isRead: notification.isRead,
          postId: notification.targetId,
          onUserTap: () {
            _markAsRead(notification.id);
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
          onMessageTap: () async {
            _markAsRead(notification.id);
            final postId = notification.targetId;
            if (postId != null && postId.isNotEmpty) {
              // Navigate to loading page with smooth fade animation
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const _PostLoadingPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
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
                          PostDetailPage(post: result.data!),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  );
                } else {
                  // Post doesn't exist or error loading
                  Navigator.of(context).pop(); // Close loading page

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bài viết không tồn tại')),
                  );

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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Thông báo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          // Update scroll listener with current state flags
          if (_scrollListener != null) {
            _scrollController.removeListener(_scrollListener!);
          }
          _scrollListener = () =>
              _onScroll(state.hasMore, state.isLoadingMore, context);
          _scrollController.addListener(_scrollListener!);

          if (state.notifications.isEmpty) {
            return const Center(child: Text('Chưa có thông báo'));
          }

          // Separate unread and read notifications
          final unreadNotifications = state.notifications
              .where((n) => !n.isRead)
              .toList();
          final readNotifications = state.notifications
              .where((n) => n.isRead)
              .toList();

          return ListView(
            controller: _scrollController,
            children: [
              // "Mới" section (unread notifications)
              if (unreadNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Mới',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...unreadNotifications.map((n) => _buildNotificationItem(n)),
              ],
              // "Cũ hơn" section (read notifications)
              // Only show title if there are both unread and read notifications
              if (readNotifications.isNotEmpty &&
                  unreadNotifications.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Cũ hơn',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              // Show read notifications (with or without title)
              if (readNotifications.isNotEmpty)
                ...readNotifications.map((n) => _buildNotificationItem(n)),

              // Loading indicator when loading more
              if (state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),

              // Show "end of data" message when no more pages
              if (!state.hasMore && !state.isLoadingMore) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Đã hiển thị hết thông báo',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
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
            const _PostLoadingPage(),
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

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bài viết không tồn tại')));

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
    if (_scrollListener != null) {
      _scrollController.removeListener(_scrollListener!);
    }
    _scrollController.dispose();
    super.dispose();
  }
}

class _PostLoadingPage extends StatelessWidget {
  const _PostLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar giả (Khớp với nút back và tên tiêu đề)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Giả lập nút Back
                    _buildBox(width: 30, height: 30, radius: 8),
                    const SizedBox(width: 60), // Khoảng cách tới title
                    // Giả lập Title chính giữa/phía sau
                    _buildBox(width: 150, height: 24, radius: 8),
                  ],
                ),
              ),
              const Divider(thickness: 1, color: Colors.white), // Đường kẻ mờ

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 2. Header: Avatar + Tên người đăng
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBox(width: 160, height: 16, radius: 10),
                            const SizedBox(height: 8),
                            _buildBox(width: 100, height: 12, radius: 10),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 3. Text lines (Nội dung ngắn)
                    _buildBox(width: double.infinity, height: 14, radius: 10),
                    const SizedBox(height: 8),
                    _buildBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 14,
                      radius: 10,
                    ),
                    const SizedBox(height: 16),

                    // 4. Post Body (Khung ảnh)
                    _buildBox(width: double.infinity, height: 250, radius: 15),
                    const SizedBox(height: 20),

                    // 5. Action Buttons (Like, Comment, Share)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBox(width: 85, height: 35, radius: 20),
                        _buildBox(width: 85, height: 35, radius: 20),
                        _buildBox(width: 85, height: 35, radius: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
