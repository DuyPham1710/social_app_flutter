import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_status_model.freezed.dart';
part 'member_status_model.g.dart';

@freezed
class MemberStatusModel with _$MemberStatusModel {
  const factory MemberStatusModel({
    required String status, // 'member', 'invited', 'pending', 'none'
    required String? role, // 'admin', 'member', null
  }) = _MemberStatusModel;

  factory MemberStatusModel.fromJson(Map<String, dynamic> json) =>
      _$MemberStatusModelFromJson(json);
}
