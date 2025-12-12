import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel extends NotificationEntity with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: '_id') required String id,
    required String receiver,
    UserModel? sender,
    required String type,
    required String targetId,
    required String message,
    required bool isRead,
    required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
