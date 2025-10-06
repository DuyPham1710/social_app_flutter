import 'package:freezed_annotation/freezed_annotation.dart';
import 'post_model.dart';

part 'post_list_response.freezed.dart';
part 'post_list_response.g.dart';

@freezed
class PostListResponse with _$PostListResponse {
  const factory PostListResponse({
    required List<PostModel> data,
    int? page,
    int? limit,
    int? total,
    bool? hasNext,
  }) = _PostListResponse;

  factory PostListResponse.fromJson(Map<String, dynamic> json) =>
      _$PostListResponseFromJson(json);
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
