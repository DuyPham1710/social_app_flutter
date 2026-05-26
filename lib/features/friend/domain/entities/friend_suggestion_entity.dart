abstract class FriendSuggestionEntity {
  String get userId;
  String? get fullName;
  String? get username;
  String? get avatarUrl;
  String? get bio;
  int? get mutualFriends;
  String? get reason;
  List<String>? get mutualFriendAvatars;
}
