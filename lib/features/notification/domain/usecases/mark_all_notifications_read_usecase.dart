import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsReadUseCase implements SyncUseCase<void, NoParams> {
  final NotificationRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  @override
  void call({NoParams? params}) {
    repository.markAllRead();
  }
}
