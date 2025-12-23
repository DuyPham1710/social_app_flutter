import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel extends UserEntity with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? phoneNumber,
    @JsonKey(includeIfNull: false) String? bio,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? dateOfBirth,
    @JsonKey(includeIfNull: false) String? gender,
    @JsonKey(includeIfNull: false) String? email,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) bool? isActive,
    @JsonKey(includeIfNull: false) DateTime? createdAt,
    @JsonKey(includeIfNull: false) String? coverUrl,
    @JsonKey(includeIfNull: false) String? school,
    @JsonKey(includeIfNull: false) String? currentCity,
    @JsonKey(includeIfNull: false) String? hometown,
    @JsonKey(includeIfNull: false) String? workplace,
    @JsonKey(includeIfNull: false) String? relationshipStatus,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
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
  );
}
