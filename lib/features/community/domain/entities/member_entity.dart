import 'package:social_app_fe/features/auth/data/models/user_model.dart';

class MemberEntity {
  final String id;
  final UserModel user;
  final String role;
  final DateTime? createdAt;

  MemberEntity({
    required this.id,
    required this.user,
    required this.role,
    this.createdAt,
  });
}
