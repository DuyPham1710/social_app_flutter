import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import 'package:social_app_fe/features/notification/presentation/services/notification_sound_service.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  StreamSubscription? _listSub;
  StreamSubscription? _newSub;
  StreamSubscription? _unreadSub;
  StreamSubscription? _hasMoreSub;

  NotificationBloc(this.repository) : super(NotificationState.initial()) {
    on<LoadMoreNotificationsEvent>(_onLoadMoreNotifications);
    on<ConnectNotificationSocket>((event, emit) {
      repository.connect(event.userId);

      _listSub?.cancel();
      _newSub?.cancel();
      _unreadSub?.cancel();
      _hasMoreSub?.cancel();

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

    on<NotificationsLoaded>((event, emit) {
      // Count unread notifications from the loaded list
      final unreadCount = event.notifications.where((n) => !n.isRead).length;
      emit(
        NotificationState(
          notifications: event.notifications,
          unread: unreadCount,
          hasMore: state.hasMore,
          isLoadingMore: false,
        ),
      );
    });

    on<NewNotificationReceived>((event, emit) {
      NotificationSoundService.play();
      emit(
        NotificationState(
          notifications: [event.notification, ...state.notifications],
          unread: state.unread + 1,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
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
        ),
      );
    });

    on<MarkNotificationRead>((event, emit) => repository.markRead(event.id));

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
        ),
      );

      // Then send to server
      repository.markAllRead();
    });

    on<RemoveNotification>((event, emit) {
      final updatedNotifications = state.notifications
          .where((n) => n.id != event.id)
          .toList();
      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      // Emit updated list immediately
      emit(
        NotificationState(
          notifications: updatedNotifications,
          unread: unreadCount,
          hasMore: state.hasMore,
          isLoadingMore: state.isLoadingMore,
        ),
      );

      // Also tell repository to mark it read/handled if supported
      try {
        repository.markRead(event.id);
      } catch (_) {}
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
}
