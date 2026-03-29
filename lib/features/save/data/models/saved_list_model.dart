import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/features/save/data/models/saved_model.dart';

part 'saved_list_model.freezed.dart';
part 'saved_list_model.g.dart';

@freezed
class SavedListModel with _$SavedListModel {
  const factory SavedListModel({
    required List<SavedModel> data,
    @Default(0) int total,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _SavedListModel;

  factory SavedListModel.fromJson(Map<String, dynamic> json) =>
      _$SavedListModelFromJson(json);
}
