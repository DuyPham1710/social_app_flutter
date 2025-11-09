import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';

part 'privacy_model.freezed.dart';
part 'privacy_model.g.dart';

@freezed
class PrivacyModel extends PrivacyEntity with _$PrivacyModel {
  const factory PrivacyModel({
    @JsonKey(name: 'userId') UserModel? user,
    required PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except')
    @Default([])
    List<UserModel>? friendsExcept,
    @JsonKey(name: 'friends_detail')
    @Default([])
    List<UserModel>? friendsDetail,
  }) = _PrivacyModel;

  factory PrivacyModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyModelFromJson(json);
}
