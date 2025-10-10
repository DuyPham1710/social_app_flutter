import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/post/domain/entities/post_url_entity.dart';

part 'post_url_model.freezed.dart';
part 'post_url_model.g.dart';

@freezed
class PostUrlModel extends PostUrlEntity with _$PostUrlModel {
  const factory PostUrlModel({
    @JsonKey(name: '_id') required String id,
    required String url,
    String? title,
    required int order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PostUrlModel;

  factory PostUrlModel.fromJson(Map<String, dynamic> json) =>
      _$PostUrlModelFromJson(json);
}
