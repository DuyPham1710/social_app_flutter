// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchResultModelImpl _$$SearchResultModelImplFromJson(
  Map<String, dynamic> json,
) => _$SearchResultModelImpl(
  userResponseDtos: (json['userResponseDtos'] as List<dynamic>)
      .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: PaginationModel.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$SearchResultModelImplToJson(
  _$SearchResultModelImpl instance,
) => <String, dynamic>{
  'userResponseDtos': instance.userResponseDtos,
  'pagination': instance.pagination,
};

_$PaginationModelImpl _$$PaginationModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaginationModelImpl(
  currentPage: (json['currentPage'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  itemsPerPage: (json['itemsPerPage'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  hasPrevPage: json['hasPrevPage'] as bool,
);

Map<String, dynamic> _$$PaginationModelImplToJson(
  _$PaginationModelImpl instance,
) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'totalPages': instance.totalPages,
  'totalItems': instance.totalItems,
  'itemsPerPage': instance.itemsPerPage,
  'hasNextPage': instance.hasNextPage,
  'hasPrevPage': instance.hasPrevPage,
};
