import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';

class NotificationEntity {
  final String id;
  final NotificationType type;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final UserEntity? sender;
  final String? targetId;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.sender,
    this.targetId,
  });
}
