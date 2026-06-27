import 'package:social_app_fe/features/auth/data/models/user_model.dart';

class CommunityEntity {
  final String id;
  final String name;
  final String description;
  final String avatar;
  final String coverImage;
  final String privacy;
  final String? type;
  final int memberCount;
  final UserModel admin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CommunityEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.avatar,
    required this.coverImage,
    required this.privacy,
    this.type,
    required this.memberCount,
    required this.admin,
    this.createdAt,
    this.updatedAt,
  });
}
