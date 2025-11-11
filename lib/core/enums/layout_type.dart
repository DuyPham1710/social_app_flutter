import 'package:freezed_annotation/freezed_annotation.dart';

enum LayoutType {
  @JsonValue('classic')
  classic,
  @JsonValue('column')
  column,
  @JsonValue('frame')
  frame,
}
