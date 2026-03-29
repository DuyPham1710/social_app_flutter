// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedListModelImpl _$$SavedListModelImplFromJson(Map<String, dynamic> json) =>
    _$SavedListModelImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => SavedModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$SavedListModelImplToJson(
  _$SavedListModelImpl instance,
) => <String, dynamic>{
  'data': instance.data,
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
};
