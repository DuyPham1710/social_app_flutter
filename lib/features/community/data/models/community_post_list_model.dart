import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/community/data/models/community_post_model.dart';

part 'community_post_list_model.freezed.dart';
part 'community_post_list_model.g.dart';

@freezed
class CommunityPostListModel with _$CommunityPostListModel {
  const factory CommunityPostListModel({
    required List<CommunityPostModel> data,
    required int page,
    required int limit,
    required int total,
    required bool hasNext,
  }) = _CommunityPostListModel;

  factory CommunityPostListModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostListModelFromJson(json);
}
