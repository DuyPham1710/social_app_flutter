// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_story_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupedUserStoryModelImpl _$$GroupedUserStoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$GroupedUserStoryModelImpl(
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  stories: (json['stories'] as List<dynamic>)
      .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$GroupedUserStoryModelImplToJson(
  _$GroupedUserStoryModelImpl instance,
) => <String, dynamic>{'user': instance.user, 'stories': instance.stories};

_$GroupedStoryListModelImpl _$$GroupedStoryListModelImplFromJson(
  Map<String, dynamic> json,
) => _$GroupedStoryListModelImpl(
  users: (json['users'] as List<dynamic>)
      .map((e) => GroupedUserStoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
);

Map<String, dynamic> _$$GroupedStoryListModelImplToJson(
  _$GroupedStoryListModelImpl instance,
) => <String, dynamic>{
  'users': instance.users,
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'hasNext': instance.hasNext,
};
