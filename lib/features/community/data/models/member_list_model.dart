import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/community/data/models/member_model.dart';

part 'member_list_model.freezed.dart';
part 'member_list_model.g.dart';

@freezed
class MemberListModel with _$MemberListModel {
  const factory MemberListModel({
    required List<MemberModel> data,
    required int page,
    required int limit,
    required int total,
    required bool hasNext,
  }) = _MemberListModel;

  factory MemberListModel.fromJson(Map<String, dynamic> json) =>
      _$MemberListModelFromJson(json);
}
