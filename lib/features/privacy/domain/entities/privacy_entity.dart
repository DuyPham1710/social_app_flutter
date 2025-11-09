import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

class PrivacyEntity {
  final UserEntity? user;
  final PrivacyType defaultPrivacy;
  final List<UserEntity>? friendsExcept;
  final List<UserEntity>? friendsDetail;

  PrivacyEntity({
    this.user,
    required this.defaultPrivacy,
    this.friendsExcept,
    this.friendsDetail,
  });
}
