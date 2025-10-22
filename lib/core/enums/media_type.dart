import 'package:freezed_annotation/freezed_annotation.dart';

enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('text')
  text,
}
