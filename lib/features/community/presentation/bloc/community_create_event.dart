abstract class CommunityCreateEvent {
  CommunityCreateEvent();
}

class CreateCommunityRequested extends CommunityCreateEvent {
  final String name;
  final String? description;
  final String privacy;
  final String? avatarPath;
  final String? coverImagePath;

  CreateCommunityRequested({
    required this.name,
    this.description,
    required this.privacy,
    this.avatarPath,
    this.coverImagePath,
  });
}

class UpdateCommunityRequested extends CommunityCreateEvent {
  final String communityId;
  final String? name;
  final String? description;
  final String? privacy;
  final String? avatarPath;
  final String? coverImagePath;

  UpdateCommunityRequested({
    required this.communityId,
    this.name,
    this.description,
    this.privacy,
    this.avatarPath,
    this.coverImagePath,
  });
}
