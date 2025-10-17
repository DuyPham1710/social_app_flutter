// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendModelImpl _$$FriendModelImplFromJson(Map<String, dynamic> json) =>
    _$FriendModelImpl(
      userId: json['_id'] as String,
      fullName: json['fullName'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      mutualFriendsCount: (json['mutualFriendsCount'] as num?)?.toInt(),
      mutualFriendAvatars: (json['mutualFriendAvatars'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$FriendModelImplToJson(_$FriendModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.userId,
      if (instance.fullName case final value?) 'fullName': value,
      if (instance.username case final value?) 'username': value,
      if (instance.avatarUrl case final value?) 'avatarUrl': value,
      if (instance.bio case final value?) 'bio': value,
      if (instance.mutualFriendsCount case final value?)
        'mutualFriendsCount': value,
      if (instance.mutualFriendAvatars case final value?)
        'mutualFriendAvatars': value,
    };
