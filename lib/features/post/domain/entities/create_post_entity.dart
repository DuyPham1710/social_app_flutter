import 'dart:io';
import 'dart:typed_data';
import 'package:social_app_fe/core/enums/layout_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';

class CreatePostEntity {
  final String? caption;
  final String? location;
  final List<File>? files;
  final List<String>? titles;
  final List<int>? orders;
  final LayoutType? layout;
  final PrivacyType? privacyType;
  final List<String>? friendsExcept;
  final List<String>? friendsDetail;
  final List<String>? taggedUserIds;
  final String? communityId;
  final List<Uint8List>? fileBytesList;
  final List<String>? fileNames;

  const CreatePostEntity({
    this.caption,
    this.location,
    this.files,
    this.titles,
    this.orders,
    this.layout,
    this.privacyType,
    this.friendsExcept,
    this.friendsDetail,
    this.taggedUserIds,
    this.communityId,
    this.fileBytesList,
    this.fileNames,
  });
}
