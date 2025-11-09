import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';

part 'update_privacy_model.freezed.dart';
part 'update_privacy_model.g.dart';

@freezed
class UpdatePrivacyModel with _$UpdatePrivacyModel {
  const factory UpdatePrivacyModel({
    required PrivacyType defaultPrivacy,
    @JsonKey(name: 'friends_except') @Default([]) List<String>? friendsExcept,
    @JsonKey(name: 'friends_detail') @Default([]) List<String>? friendsDetail,
  }) = _UpdatePrivacyModel;

  factory UpdatePrivacyModel.fromJson(Map<String, dynamic> json) =>
      _$UpdatePrivacyModelFromJson(json);
}
