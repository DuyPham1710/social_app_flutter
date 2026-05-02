import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/community/domain/entities/community_ref_entity.dart';

part 'community_ref_model.freezed.dart';
part 'community_ref_model.g.dart';

@freezed
class CommunityRefModel with _$CommunityRefModel {
  const factory CommunityRefModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? avatar,
  }) = _CommunityRefModel;

  factory CommunityRefModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityRefModelFromJson(json);
}

extension CommunityRefModelMapper on CommunityRefModel {
  CommunityRefEntity toEntity() =>
      CommunityRefEntity(id: id, name: name, avatar: avatar);
}
