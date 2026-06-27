import 'dart:io';
import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:social_app_fe/core/enums/layout_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';

part 'create_post_model.freezed.dart';
part 'create_post_model.g.dart';

@freezed
class CreatePostModel with _$CreatePostModel {
  const factory CreatePostModel({
    String? caption,
    String? location,
    double? latitude,
    double? longitude,
    @JsonKey(ignore: true) List<File>? files,
    List<String>? titles,
    List<int>? orders,
    LayoutType? layout,
    PrivacyType? privacyType,
    List<String>? friendsExcept,
    List<String>? friendsDetail,
    List<String>? taggedUserIds,
    String? communityId,
    @JsonKey(ignore: true) List<Uint8List>? fileBytesList,
    @JsonKey(ignore: true) List<String>? fileNames,
  }) = _CreatePostModel;

  factory CreatePostModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePostModelFromJson(json);

  /// Convert từ Entity sang Model
  factory CreatePostModel.fromEntity(CreatePostEntity entity) {
    return CreatePostModel(
      caption: entity.caption,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      files: entity.files,
      titles: entity.titles,
      orders: entity.orders,
      layout: entity.layout,
      privacyType: entity.privacyType,
      friendsExcept: entity.friendsExcept,
      friendsDetail: entity.friendsDetail,
      taggedUserIds: entity.taggedUserIds,
      communityId: entity.communityId,
      fileBytesList: entity.fileBytesList,
      fileNames: entity.fileNames,
    );
  }
}
