import 'package:social_app_fe/features/auth/data/models/user_model.dart';

class CommunityRequestEntity {
  final String id;
  final UserModel user;
  final String type; // 'join', 'invite'
  final String status; // 'pending', 'approved', 'rejected'
  final UserModel? sender;
  final DateTime? createdAt;

  CommunityRequestEntity({
    required this.id,
    required this.user,
    required this.type,
    required this.status,
    this.sender,
    this.createdAt,
  });
}
