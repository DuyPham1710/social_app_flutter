class CommunityInviteEntity {
  final String id;
  final String userId;
  final CommunityInfoEntity communityId;
  final String type;
  final String status;
  final DateTime createdAt;

  CommunityInviteEntity({
    required this.id,
    required this.userId,
    required this.communityId,
    required this.type,
    required this.status,
    required this.createdAt,
  });
}

class CommunityInfoEntity {
  final String id;
  final String name;
  final String? avatar;
  final String? description;

  CommunityInfoEntity({
    required this.id,
    required this.name,
    this.avatar,
    this.description,
  });
}
