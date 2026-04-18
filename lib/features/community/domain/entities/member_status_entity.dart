class MemberStatusEntity {
  final String status; // 'member', 'invited', 'pending', 'none'
  final String? role; // 'admin', 'member', null

  MemberStatusEntity({required this.status, required this.role});
}
