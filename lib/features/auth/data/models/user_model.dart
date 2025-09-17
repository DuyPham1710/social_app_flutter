import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel extends UserEntity with _$UserModel {
  const factory UserModel({
    required String userId,
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
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
