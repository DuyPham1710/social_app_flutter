import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/post/domain/entities/post_list_entity.dart';
import 'post_model.dart';

part 'post_list_model.freezed.dart';
part 'post_list_model.g.dart';

@freezed
class PostListModel extends PostListEntity with _$PostListModel {
  const factory PostListModel({
    required List<PostModel> data,
    int? page,
    int? limit,
    int? total,
    bool? hasNext,
  }) = _PostListModel;

  factory PostListModel.fromJson(Map<String, dynamic> json) =>
      _$PostListModelFromJson(json);
}

// @freezed
// class PostListData with _$PostListData {
//   const factory PostListData({
//     required List<PostModel> data,
//     int? page,
//     int? limit,
//     int? total,
//     bool? hasNext,
//   }) = _PostListData;

//   factory PostListData.fromJson(Map<String, dynamic> json) =>
//       _$PostListDataFromJson(json);
// }
