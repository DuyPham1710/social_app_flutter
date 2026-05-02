import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_invite_model.freezed.dart';
part 'community_invite_model.g.dart';

@freezed
class CommunityInviteModel with _$CommunityInviteModel {
  const factory CommunityInviteModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required CommunityInfoModel communityId,
    required String type,
    required String status,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _CommunityInviteModel;

  factory CommunityInviteModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityInviteModelFromJson(json);
}

@freezed
class CommunityInfoModel with _$CommunityInfoModel {
  const factory CommunityInfoModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? avatar,
    String? description,
  }) = _CommunityInfoModel;

  factory CommunityInfoModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityInfoModelFromJson(json);
}
