import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/save/domain/entities/saved_entity.dart';
import 'package:social_app_fe/features/auth/data/models/user_model.dart';

part 'saved_model.freezed.dart';
part 'saved_model.g.dart';

@freezed
class SavedModel extends SavedEntity with _$SavedModel {
  const factory SavedModel({
    @JsonKey(name: '_id') required String id,
    // required String userId,
    @JsonKey(name: 'userId') required String userId,
    required String targetId,
    required String type,
    @Default('') String content,
    @Default('default') String collection,
    @Default('') String note,
    DateTime? createdAt,
    String? authorId,
    String? authorName,
    String? authorAvatar,
  }) = _SavedModel;

  factory SavedModel.fromJson(Map<String, dynamic> json) =>
      _$SavedModelFromJson(json);
}
