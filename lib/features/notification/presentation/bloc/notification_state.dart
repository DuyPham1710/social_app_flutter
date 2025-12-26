import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

class NotificationState {
  final List<NotificationEntity> notifications;
  final int unread;
  final bool hasMore; // track if more pages available
  final bool isLoadingMore; // track if currently loading more pages
  final bool isInitialLoading; // track initial loading state
  final bool isReloading; // track reload state

  const NotificationState({
    this.notifications = const [],
    this.unread = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isInitialLoading = false,
    this.isReloading = false,
  });

  factory NotificationState.initial() => const NotificationState(
    notifications: [],
    unread: 0,
    hasMore: true,
    isLoadingMore: false,
    isInitialLoading: true, // Start with loading state
    isReloading: false,
  );

  NotificationState copyWith({
    List<NotificationEntity>? notifications,
    int? unread,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isInitialLoading,
    bool? isReloading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unread: unread ?? this.unread,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isReloading: isReloading ?? this.isReloading,
    );
  }
}
