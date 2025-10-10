import 'package:freezed_annotation/freezed_annotation.dart';

enum PrivacyType {
  @JsonValue('public')
  public,

  @JsonValue('friends')
  friends,

  @JsonValue('friends_except')
  friendsExcept,

  @JsonValue('friends_detail')
  friendsDetail,

  @JsonValue('private')
  private,
}
