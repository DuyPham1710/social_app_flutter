import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel extends UserEntity with _$UserModel {
  const factory UserModel({
    required String userId,
    required String fullName,
    required String phoneNumber,
    required String bio,
    required String avatarUrl,
    required String dateOfBirth,
    required String gender,
    required String email,
    required String username,
    required bool isActive,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
