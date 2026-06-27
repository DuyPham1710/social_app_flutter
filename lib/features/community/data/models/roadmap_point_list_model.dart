import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/community/data/models/roadmap_point_model.dart';

part 'roadmap_point_list_model.freezed.dart';
part 'roadmap_point_list_model.g.dart';

@freezed
class RoadmapPointListModel with _$RoadmapPointListModel {
  const factory RoadmapPointListModel({
    required List<RoadmapPointModel> data,
    required int page,
    required int limit,
    required int total,
    required bool hasNext,
  }) = _RoadmapPointListModel;

  factory RoadmapPointListModel.fromJson(Map<String, dynamic> json) =>
      _$RoadmapPointListModelFromJson(json);
}
