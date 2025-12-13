import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  StreamSubscription? _listSub;
  StreamSubscription? _newSub;
  StreamSubscription? _unreadSub;

  NotificationBloc(this.repository) : super(NotificationState.initial()) {
    on<ConnectNotificationSocket>((event, emit) {
      repository.connect(event.userId);

      _listSub?.cancel();
      _newSub?.cancel();
      _unreadSub?.cancel();

      _listSub = repository.notifications.listen(
        (list) => add(NotificationsLoaded(list)),
      );

      _newSub = repository.newNotification.listen(
        (n) => add(NewNotificationReceived(n)),
      );

      _unreadSub = repository.unreadCount.listen(
        (u) => add(UnreadCountUpdated(u)),
      );
    });

    on<NotificationsLoaded>((event, emit) {
      emit(
        NotificationState(
          notifications: event.notifications,
          unread: state.unread,
        ),
      );
    });

    on<NewNotificationReceived>((event, emit) {
      emit(
        NotificationState(
          notifications: [event.notification, ...state.notifications],
          unread: state.unread + 1,
        ),
      );
    });

    on<UnreadCountUpdated>((event, emit) {
      emit(
        NotificationState(
          notifications: state.notifications,
          unread: event.unread,
        ),
      );
    });

    on<MarkNotificationRead>((event, emit) => repository.markRead(event.id));

    on<MarkAllNotificationsRead>((event, emit) => repository.markAllRead());
  }

  @override
  Future<void> close() {
    _listSub?.cancel();
    _newSub?.cancel();
    _unreadSub?.cancel();
    return super.close();
  }
}
