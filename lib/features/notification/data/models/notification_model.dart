import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/notification_type.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/notification/domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: '_id') required String id,

    required String type,
    required String message,
    required bool isRead,

    @JsonKey(fromJson: _dateTimeFromJson) DateTime? createdAt,

    UserModel? sender,
    String? targetId,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// 👇 SOCKET SAFE PARSER
DateTime? _dateTimeFromJson(dynamic value) {
  if (value == null) return null;
  if (value is String) return DateTime.tryParse(value);
  if (value is DateTime) return value;
  return null;
}

extension NotificationModelMapper on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    type: NotificationType.values.firstWhere(
      (e) => e.name == type,
      orElse: () => NotificationType.UNKNOWN,
    ),
    message: message,
    isRead: isRead,
    createdAt: createdAt ?? DateTime.now(), // 👈 fallback an toàn
    sender: sender?.toEntity(),
    targetId: targetId,
  );
}
