import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  StreamSubscription? _listSub;
  StreamSubscription? _newSub;
  StreamSubscription? _unreadSub;
  StreamSubscription? _hasMoreSub;

  NotificationBloc(this.repository) : super(NotificationState.initial()) {
    on<LoadMoreNotificationsEvent>(_onLoadMoreNotifications);
    on<ClearNotificationCache>(_onClearCache);
    on<ReloadNotifications>(_onReloadNotifications);
    on<ConnectNotificationSocket>((event, emit) {
      // Cancel previous subscriptions
      _listSub?.cancel();
      _newSub?.cancel();
      _unreadSub?.cancel();
      _hasMoreSub?.cancel();

      // Connect with new userId
      repository.connect(event.userId);

      _listSub = repository.notifications.listen(
        (list) => add(NotificationsLoaded(list)),
      );

      _newSub = repository.newNotification.listen(
        (n) => add(NewNotificationReceived(n)),
      );

      _unreadSub = repository.unreadCount.listen(
        (u) => add(UnreadCountUpdated(u)),
      );

      // Listen to hasMore updates so UI can stop requesting pages
      _hasMoreSub = repository.hasMore.listen((b) => add(HasMoreUpdated(b)));
    });

    on<DisconnectNotificationSocket>((event, emit) {
      // Cancel all subscriptions
      _listSub?.cancel();
      _newSub?.cancel();
      _unreadSub?.cancel();
      _hasMoreSub?.cancel();

      // Disconnect from socket
      repository.disconnect();

      // Reset state
      emit(NotificationState.initial());
    });

    on<NotificationsLoaded>((event, emit) {
      // Count unread notifications from the loaded list
      final unreadCount = event.notifications.where((n) => !n.isRead).length;
      emit(
        NotificationState(
          notifications: event.notifications,
          unread: unreadCount,
          hasMore: state.hasMore,
          isLoadingMore: false,
          isInitialLoading: false, // Initial loading completed
          isReloading: false, // Reload completed
        ),
      );
    });

    on<NewNotificationReceived>((event, emit) {
      emit(
        NotificationState(
          notifications: [event.notification, ...state.notifications],
          unread: state.unread + 1,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          isInitialLoading: state.isInitialLoading,
          isReloading: state.isReloading,
        ),
      );
    });

    on<UnreadCountUpdated>((event, emit) {
      emit(
        NotificationState(
          notifications: state.notifications,
          unread: event.unread,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          isInitialLoading: state.isInitialLoading,
          isReloading: state.isReloading,
        ),
      );
    });

    on<HasMoreUpdated>((event, emit) {
      emit(
        NotificationState(
          notifications: state.notifications,
          unread: state.unread,
          hasMore: event.hasMore,
          isLoadingMore: false,
          isInitialLoading: state.isInitialLoading,
          isReloading: state.isReloading,
        ),
      );
    });

    on<MarkNotificationRead>((event, emit) {
      // Update the specific notification to be read in the list
      final updatedNotifications = state.notifications
          .map(
            (n) => n.id == event.id
                ? NotificationEntity(
                    id: n.id,
                    type: n.type,
                    message: n.message,
                    content: n.content,
                    isRead: true,
                    createdAt: n.createdAt,
                    sender: n.sender,
                    targetId: n.targetId,
                  )
                : n,
          )
          .toList();

      // Recalculate unread count
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      emit(
        NotificationState(
          notifications: updatedNotifications,
          unread: unreadCount,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          isInitialLoading: state.isInitialLoading,
          isReloading: state.isReloading,
        ),
      );

      // Send to server
      repository.markRead(event.id);
    });

    on<MarkAllNotificationsRead>((event, emit) async {
      // Update all notifications to be read immediately
      final updatedNotifications = state.notifications
          .map(
            (n) => NotificationEntity(
              id: n.id,
              type: n.type,
              message: n.message,
              content: n.content,
              isRead: true,
              createdAt: n.createdAt,
              sender: n.sender,
              targetId: n.targetId,
            ),
          )
          .toList();
      emit(
        NotificationState(
          notifications: updatedNotifications,
          unread: 0,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          isInitialLoading: state.isInitialLoading,
          isReloading: state.isReloading,
        ),
      );

      // Then send to server
      repository.markAllRead();
    });

    on<RemoveNotification>((event, emit) {
      print(
        '[NotificationBloc] RemoveNotification event received for id: ${event.id}',
      );
      print(
        '[NotificationBloc] Current notifications count: ${state.notifications.length}',
      );

      final updatedNotifications = state.notifications
          .where((n) => n.id != event.id)
          .toList();
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      print(
        '[NotificationBloc] After filtering, notifications count: ${updatedNotifications.length}',
      );

      // Emit updated list immediately
      emit(
        NotificationState(
          notifications: updatedNotifications,
          unread: unreadCount,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
          isInitialLoading: state.isInitialLoading,
        ),
      );

      print(
        '[NotificationBloc] New state emitted with ${updatedNotifications.length} notifications',
      );

      // Tell repository to delete from cache and server
      try {
        repository.deleteNotification(event.id);
        print('[NotificationBloc] Repository deleteNotification called');
      } catch (e) {
        print('[NotificationBloc] Error calling deleteNotification: $e');
      }
    });
  }

  Future<void> _onLoadMoreNotifications(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // Don't load more if already loading or no more data
    if (state.isLoadingMore || !state.hasMore) {
      return;
    }

    // Emit state with isLoadingMore = true
    emit(
      NotificationState(
        notifications: state.notifications,
        unread: state.unread,
        hasMore: state.hasMore,
        isLoadingMore: true,
        isInitialLoading: state.isInitialLoading,
      ),
    );

    // Request next page
    try {
      repository.loadPage(page: event.page, limit: event.limit);
    } catch (_) {
      // On error, reset isLoadingMore and keep data
      emit(
        NotificationState(
          notifications: state.notifications,
          unread: state.unread,
          hasMore: state.hasMore,
          isLoadingMore: false,
          isInitialLoading: state.isInitialLoading,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _listSub?.cancel();
    _newSub?.cancel();
    _unreadSub?.cancel();
    _hasMoreSub?.cancel();
    return super.close();
  }

  Future<void> _onClearCache(
    ClearNotificationCache event,
    Emitter<NotificationState> emit,
  ) async {
    // Clear cache and reset to initial state
    repository.clearCache();
    emit(NotificationState.initial());
  }

  Future<void> _onReloadNotifications(
    ReloadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    // Show reload state while keeping current data
    emit(
      NotificationState(
        notifications: state.notifications,
        unread: state.unread,
        hasMore: true,
        isLoadingMore: false,
        isInitialLoading: false,
        isReloading: true, // Mark as reloading
      ),
    );

    repository.loadPage(page: 1, limit: 10);
  }
}
