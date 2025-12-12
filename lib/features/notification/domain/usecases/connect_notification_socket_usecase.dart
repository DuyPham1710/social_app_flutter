import 'package:social_app_fe/core/usecase/usecase.dart';
import 'package:social_app_fe/features/notification/domain/repository/notification_repository.dart';

class ConnectNotificationSocketUseCase
    implements SyncUseCase<void, ConnectNotificationParams> {
  final NotificationRepository repository;

  ConnectNotificationSocketUseCase(this.repository);

  @override
  void call({required ConnectNotificationParams params}) {
    repository.connect(params.userId);
  }
}

class ConnectNotificationParams {
  final String userId;
  ConnectNotificationParams(this.userId);
}
