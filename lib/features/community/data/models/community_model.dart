import 'package:freezed_annotation/freezed_annotation.dart';

part 'community_model.freezed.dart';
part 'community_model.g.dart';

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  return DateTime.now();
}

String _extractAdminId(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    return (value['_id'] ?? value['id'] ?? '') as String;
  }
  return '';
}

@freezed
class CommunityModel with _$CommunityModel {
  const factory CommunityModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    String? description,
    String? avatar,
    String? coverImage,
    required int memberCount,
    @JsonKey(fromJson: _parseDateTime) required DateTime createdAt,
    @JsonKey(name: 'adminId', fromJson: _extractAdminId)
    required String createdBy,
    @JsonKey(name: 'privacy') String? status,
    String? type,
    @JsonKey(name: 'myRole') String? myRole,
    @JsonKey(name: 'memberStatus') String? memberStatus,
  }) = _CommunityModel;

  factory CommunityModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityModelFromJson(json);
}
