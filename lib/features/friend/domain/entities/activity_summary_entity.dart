class ActivitySummaryEntity {
  final ActivityCountsEntity activities;
  final String summary;

  const ActivitySummaryEntity({
    required this.activities,
    required this.summary,
  });
}

class ActivityCountsEntity {
  final int postCount;
  final int commentCount;
  final int reactCount;
  final int storyCount;

  const ActivityCountsEntity({
    required this.postCount,
    required this.commentCount,
    required this.reactCount,
    required this.storyCount,
  });
}
