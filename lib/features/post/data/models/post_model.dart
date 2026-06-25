import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/emoji.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/post/data/models/react_post_model.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/data/models/post_url_model.dart';
import 'package:social_app_fe/features/community/domain/entities/community_entity.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

CommunityEntity? _parseCommunity(dynamic json) {
  if (json == null) return null;
  if (json is CommunityEntity) return json;
  if (json is Map<String, dynamic>) {
    return CommunityEntity(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      avatar: json['avatar'] ?? '',
      coverImage: json['coverImage'] ?? '',
      privacy: json['privacy'] ?? 'public',
      memberCount: json['memberCount'] ?? 0,
      admin: json['admin'] != null
          ? UserModel.fromJson(json['admin'])
          : UserModel(
              userId: '',
              username: 'Unknown',
              fullName: 'Unknown',
              avatarUrl: null,
            ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
  return null;
}

Map<String, dynamic>? _serializeCommunity(CommunityEntity? community) {
  if (community == null) return null;
  return {
    '_id': community.id,
    'name': community.name,
    'description': community.description,
    'avatar': community.avatar,
    'coverImage': community.coverImage,
    'privacy': community.privacy,
    'memberCount': community.memberCount,
    'admin': community.admin,
    'createdAt': community.createdAt?.toIso8601String(),
    'updatedAt': community.updatedAt?.toIso8601String(),
  };
}

@freezed
class PostModel extends PostEntity with _$PostModel {
  const factory PostModel({
    @JsonKey(name: '_id') required String id,
    String? caption,
    String? location,
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
    @JsonKey(name: 'userId') required UserModel user,
    required List<PostUrlModel> urls,
    required String layout,
    @Default([]) List<ReactPostModel> reacts,
    @EmojiConverter() @JsonKey(name: 'isReact') EmojiType? isReact,
    @JsonKey(name: 'privacy_type')
    @Default(PrivacyType.public)
    PrivacyType privacyType,
    @JsonKey(name: 'friends_except') @Default([]) List<String> friendsExcept,
    @JsonKey(name: 'friends_detail') @Default([]) List<String> friendsDetail,
    List<UserModel>? taggedUsers,
    @Default([]) List<String> visibleOnProfileUserIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(
      name: 'communityId',
      fromJson: _parseCommunity,
      toJson: _serializeCommunity,
    )
    CommunityEntity? community,
    @JsonKey(name: 'communityStatus') String? communityStatus,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
