import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/search/domain/entities/search_result_entity.dart';

part 'search_result_model.freezed.dart';
part 'search_result_model.g.dart';

@freezed
class SearchResultModel extends SearchResultEntity with _$SearchResultModel {
  const factory SearchResultModel({
    required List<UserModel> userResponseDtos,
    required PaginationModel pagination,
  }) = _SearchResultModel;

  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResultModelFromJson(json);
}

@freezed
class PaginationModel extends PaginationEntity with _$PaginationModel {
  const factory PaginationModel({
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int itemsPerPage,
    required bool hasNextPage,
    required bool hasPrevPage,
  }) = _PaginationModel;

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}

