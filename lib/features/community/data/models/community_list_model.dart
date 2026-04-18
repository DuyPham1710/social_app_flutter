import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/community/data/models/community_model.dart';

part 'community_list_model.freezed.dart';
part 'community_list_model.g.dart';

@freezed
class CommunityListModel with _$CommunityListModel {
  const factory CommunityListModel({
    required List<CommunityModel> data,
    required int page,
    required int limit,
    required int total,
    required bool hasNext,
  }) = _CommunityListModel;

  factory CommunityListModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityListModelFromJson(json);
}
