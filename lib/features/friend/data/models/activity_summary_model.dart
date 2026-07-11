import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/friend/domain/entities/activity_summary_entity.dart';

part 'activity_summary_model.freezed.dart';
part 'activity_summary_model.g.dart';

@freezed
class ActivitySummaryModel extends ActivitySummaryEntity with _$ActivitySummaryModel {
  const factory ActivitySummaryModel({
    required ActivityCountsModel activities,
    required String summary,
  }) = _ActivitySummaryModel;

  factory ActivitySummaryModel.fromJson(Map<String, dynamic> json) => _$ActivitySummaryModelFromJson(json);
}

@freezed
class ActivityCountsModel extends ActivityCountsEntity with _$ActivityCountsModel {
  const factory ActivityCountsModel({
    required int postCount,
    required int commentCount,
    required int reactCount,
    required int storyCount,
  }) = _ActivityCountsModel;

  factory ActivityCountsModel.fromJson(Map<String, dynamic> json) => _$ActivityCountsModelFromJson(json);
}
