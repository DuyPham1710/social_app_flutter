import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';

part 'relationship_status_model.freezed.dart';
part 'relationship_status_model.g.dart';

@freezed
class RelationshipStatusModel extends RelationshipStatusEntity with _$RelationshipStatusModel {
  const factory RelationshipStatusModel({
    required String status,
    @JsonKey(includeIfNull: false) String? requestId,
    @JsonKey(includeIfNull: false) bool? canSendRequest,
    @JsonKey(includeIfNull: false) bool? canCancelRequest,
    @JsonKey(includeIfNull: false) bool? canAcceptRequest,
    @JsonKey(includeIfNull: false) bool? canRejectRequest,
  }) = _RelationshipStatusModel;

  factory RelationshipStatusModel.fromJson(Map<String, dynamic> json) =>
      _$RelationshipStatusModelFromJson(json);
}

