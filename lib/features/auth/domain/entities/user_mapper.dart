// features/auth/data/mappers/user_mapper.dart
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

extension UserEntityX on UserEntity {
  UserModel toModel() {
    return UserModel(
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      bio: bio,
      avatarUrl: avatarUrl,
      dateOfBirth: dateOfBirth,
      gender: gender,
      email: email,
      username: username,
      isActive: isActive,
      createdAt: createdAt,
      coverUrl: coverUrl,
      school: school,
      currentCity: currentCity,
      hometown: hometown,
      workplace: workplace,
      relationshipStatus: relationshipStatus,
    );
  }
}