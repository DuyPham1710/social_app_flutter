import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel extends UserEntity with _$UserModel {
  const factory UserModel({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? bio,
    String? avatarUrl,
    String? dateOfBirth,
    String? gender,
    String? email,
    String? username,
    bool? isActive,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
