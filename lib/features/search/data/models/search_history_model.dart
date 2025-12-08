import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';
import 'package:social_app_fe/features/search/domain/entities/search_history_entity.dart';

part 'search_history_model.freezed.dart';
part 'search_history_model.g.dart';

@freezed
class SearchHistoryModel extends SearchHistoryEntity with _$SearchHistoryModel {
  const factory SearchHistoryModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(includeIfNull: false) String? query,
    @JsonKey(includeIfNull: false) int? resultCount,
    @JsonKey(includeIfNull: false, name: 'viewedUser') UserModel? viewedUser,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SearchHistoryModel;

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryModelFromJson(json);
}


