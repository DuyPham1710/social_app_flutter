import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';

part 'community_request_model.freezed.dart';
part 'community_request_model.g.dart';

@freezed
class CommunityRequestModel with _$CommunityRequestModel {
  const factory CommunityRequestModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'userId') required UserModel user,
    required String type, // 'join', 'invite'
    required String status, // 'pending', 'approved', 'rejected'
    @JsonKey(name: 'senderId') UserModel? sender,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
  }) = _CommunityRequestModel;

  factory CommunityRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityRequestModelFromJson(json);
}
