import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';

class DeleteNotificationUseCase implements SyncUseCase<void, String> {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  @override
  void call({required String params}) {
    repository.deleteNotification(params);
  }
}
