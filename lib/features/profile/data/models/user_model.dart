import 'package:social_app_fe/features/profile/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.userId,
    super.fullName,
    super.phoneNumber,
    super.bio,
    super.avatarUrl,
    super.dateOfBirth,
    super.gender,
    super.email,
    super.username,
    super.isActive,
    super.createdAt,
  });

}
