import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

@freezed
class FriendModel extends FriendEntity with _$FriendModel {
  const factory FriendModel({
    @JsonKey(name: '_id') required String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? bio,
    @JsonKey(includeIfNull: false) int? mutualFriendsCount,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
    @JsonKey(includeIfNull: false) DateTime? friendsSince,
  }) = _FriendModel;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);
}
