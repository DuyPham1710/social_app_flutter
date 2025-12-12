import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class NotificationEntity {
  final String id;
  final String receiver;
  final UserEntity? sender;
  final String type;
  final String targetId;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.receiver,
    required this.sender,
    required this.type,
    required this.targetId,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}
