abstract class RelationshipStatusEntity {
  String get status;
  String? get requestId;
  bool? get canSendRequest;
  bool? get canCancelRequest;
  bool? get canAcceptRequest;
  bool? get canRejectRequest;
}

