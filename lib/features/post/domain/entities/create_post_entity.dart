import 'dart:io';
import 'package:social_app_fe/core/enums/layout_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';

class CreatePostEntity {
  final String? caption;
  final List<File>? files;
  final List<String>? titles;
  final List<int>? orders;
  final LayoutType? layout;
  final PrivacyType? privacyType;
  final List<String>? friendsExcept;
  final List<String>? friendsDetail;
  final String? communityId;

  const CreatePostEntity({
    this.caption,
    this.files,
    this.titles,
    this.orders,
    this.layout,
    this.privacyType,
    this.friendsExcept,
    this.friendsDetail,
    this.communityId,
  });
}
