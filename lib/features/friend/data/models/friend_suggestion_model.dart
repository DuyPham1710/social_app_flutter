import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_suggestion_entity.dart';

part 'friend_suggestion_model.freezed.dart';

@freezed
class FriendSuggestionModel extends FriendSuggestionEntity
    with _$FriendSuggestionModel {
  const factory FriendSuggestionModel({
    @JsonKey(name: '_id') required String userId,
    @JsonKey(includeIfNull: false) String? fullName,
    @JsonKey(includeIfNull: false) String? username,
    @JsonKey(includeIfNull: false) String? avatarUrl,
    @JsonKey(includeIfNull: false) String? bio,
    @JsonKey(includeIfNull: false) int? mutualFriends,
    @JsonKey(includeIfNull: false) String? reason,
    @JsonKey(includeIfNull: false) List<String>? mutualFriendAvatars,
  }) = _FriendSuggestionModel;

  factory FriendSuggestionModel.fromJson(Map<String, dynamic> json) {
    int? mutualFriends;
    if (json.containsKey('mutualFriendsCount')) {
      mutualFriends = (json['mutualFriendsCount'] as num?)?.toInt();
    }

    return FriendSuggestionModel(
      userId: json['_id'] as String,
      fullName: json['fullName'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      mutualFriends: mutualFriends,
      reason: json['reason'] as String?,
      mutualFriendAvatars: null,
    );
  }
}
