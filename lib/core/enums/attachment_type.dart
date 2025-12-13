import 'package:freezed_annotation/freezed_annotation.dart';

enum AttachmentType {
  @JsonValue('image')
  image,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('file')
  file,
}
